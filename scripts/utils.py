import boto3
import sys
import datetime
import yaml
import time


def read_config(path):
    with open(sys.argv[1], 'r') as stream:
        conf = yaml.safe_load(stream)

    return conf


def get_lbs(client, name: str):
    lbs = client.describe_load_balancers(Names=[name])["LoadBalancers"]
    return lbs


def get_tgs(client, arn):
    tgs = client.describe_target_groups(LoadBalancerArn=arn)["TargetGroups"]
    return tgs

def get_tgs_by_name(client, names):
    tgs = client.describe_target_groups(Names=names)["TargetGroups"]
    return tgs


def get_asg(client, prefix):
    results = []
    paginator = client.get_paginator('describe_auto_scaling_groups')
    response_iterator = paginator.paginate()
    for asg in response_iterator:
        asgs = asg["AutoScalingGroups"]
        for auto_sg in asgs:
            if auto_sg["AutoScalingGroupName"].startswith(prefix):
                results.append(auto_sg)

    return results


def create_asg(client, tpl_id, tg_arn, name, asg_conf, subnets):
    vpc_zone_ids = ','.join(subnets)
    response = client.create_auto_scaling_group(
        AutoScalingGroupName=name,
        LaunchTemplate={
            'LaunchTemplateId': tpl_id,
            'Version': '$Latest',
        },
        TargetGroupARNs=[tg_arn],
        HealthCheckType="ELB",
        HealthCheckGracePeriod=300,
        MaxInstanceLifetime=2592000,
        MaxSize=asg_conf["max"],
        MinSize=asg_conf["min"],
        DesiredCapacity=asg_conf["desired_capacity"],
        VPCZoneIdentifier=vpc_zone_ids,
    )

    return response


def delete_asg(client, asg_name, force_delete=True):
    response = client.delete_auto_scaling_group(
        AutoScalingGroupName=asg_name,
        ForceDelete=force_delete
    )
    return response


def create_listener(client, listener_conf, lb_arn, tg_arn):
    response = client.create_listener(
        DefaultActions=[
            {
                'TargetGroupArn': tg_arn,
                'Type': 'forward',
            },
        ],
        LoadBalancerArn=lb_arn,
        Port=listener_conf["port"],
        Protocol=listener_conf["protocol"],
    )
    return response

def get_listeners(client, lb_arn):
    paginator = client.get_paginator('describe_listeners')

    results = []
    response_iterator = paginator.paginate(
        LoadBalancerArn=lb_arn
    )

    for r in response_iterator:
        for l in r['Listeners']:
            results.append(l)

    return results


def modify_listener(client, listener_conf, lb_arn, tg_weights):
    response = client.modify_listener(
        DefaultActions=[
            {
                'Type': 'forward',
                'ForwardConfig': {
                    'TargetGroups': tg_weights
                }
            },
        ],
        ListenerArn=lb_arn,
        Port=listener_conf["port"],
        Protocol=listener_conf["protocol"],
    )
    return response


def get_tg_by_name(tgs, tg_name):
    for tg in tgs:
        if tg_name == tg["TargetGroupName"]:
            return tg

    return None


def create_tg(client, tg_conf, vpc_id):
    kwargs = {}
    kwargs["Name"] = tg_conf["name"]
    kwargs["Port"] = tg_conf["port"]
    kwargs["Protocol"] = tg_conf["protocol"]
    kwargs["VpcId"] = vpc_id
    kwargs["HealthCheckProtocol"] = tg_conf["protocol"]
    kwargs["HealthCheckEnabled"] = True

    kwargs["HealthCheckPath"] = "/health_check"
    if "health_check_path" in tg_conf:
        kwargs["HealthCheckPath"] = tg_conf["health_check_path"]
        
    response = client.create_target_group(**kwargs)
    print(kwargs)
    return response["TargetGroups"]


def create_lb(client, name, subnets, sgs):
    kwargs = {}
    kwargs["Name"] = name
    kwargs["Subnets"] = subnets
    kwargs["SecurityGroups"] = sgs

    response = client.create_load_balancer(**kwargs)
    return response


def get_launch_tpls(client, tpl_name):
    tpl_name = tpl_name.strip() + "*"
    response = client.describe_launch_templates(
        Filters=[
            {
                'Name': 'launch-template-name',
                'Values': [tpl_name],
            }
        ],
    )

    return response["LaunchTemplates"]


def get_max_id(l, name_key):
    max_id = None

    for obj in l:
        name = obj[name_key]

        parts = name.split("_")

        num = int(parts[-1])
        if not max_id:
            max_id = num
        else:
            if max_id < num:
                max_id = num

    return max_id


def create_launch_tpl(client, tpl_name, tpl_conf, sgs):
    response = client.create_launch_template(
        LaunchTemplateData={
            'Monitoring': {
                'Enabled': False
            },
            'KeyName': tpl_conf["key_name"],
            'DisableApiTermination': False,
            'ImageId': tpl_conf["ami_id"],
            'InstanceType': tpl_conf["instance_type"],
            'SecurityGroupIds': sgs,
            'InstanceMarketOptions': {
                'MarketType': 'spot',
                'SpotOptions': {
                    'SpotInstanceType': 'one-time',
                }
            },
        },
        LaunchTemplateName=tpl_name,
    )
    return response['LaunchTemplate']


def delete_launch_tpl(client, name):
    response = client.delete_launch_template(
        LaunchTemplateName=name,
    )

    return response


def get_target_instances(targets):
    total_count = 0
    healthy_count = 0

    instances = []
    for t in targets:
        target = t['Target']
        target_id = target["Id"]
        target_health = t['TargetHealth']['State']

        total_count += 1
        if target_health == "healthy":
            healthy_count += 1

        instances.append((target_id, target_health))

    return total_count, healthy_count, instances


def check_target_health(client, tg_arn):
    response = client.describe_target_health(
        TargetGroupArn=tg_arn,
    )
    return response["TargetHealthDescriptions"]


def set_desired_capacity_as_zero(client, asg_name):
    response = client.update_auto_scaling_group(
        AutoScalingGroupName=asg_name,
        MinSize=0,
        MaxSize=0,
        DesiredCapacity=0
    )
    return response
