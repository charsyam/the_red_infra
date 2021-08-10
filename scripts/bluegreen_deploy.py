import boto3
import sys
import datetime
import yaml
import time

from utils import *


elb_client = boto3.client('elbv2')
asg_client = boto3.client('autoscaling')
ec2_client = boto3.client('ec2')


def deploy(deploy_conf):
    lb_name = deploy_config["lb_name"]
    subnets = deploy_config["subnets"]
    sgs = deploy_config["sgs"]
    tg_conf = deploy_config["tg_conf"]
    asg_conf = deploy_config["asg_conf"]

    lb = None
    try:
        lbs = get_lbs(elb_client, deploy_config["lb_name"])
        lb = lbs[0]
    except Exception as e:
        lb = create_lb(elb_client, lb_name, subnets, sgs)["LoadBalancers"][0]
        print(lb)

    
    lb_dns = lb["DNSName"]
    lb_arn = lb["LoadBalancerArn"]
    vpc_id = lb["VpcId"]

    tgs = get_tgs(elb_client, lb_arn)
    tg = get_tg_by_name(tgs, deploy_config["tg_conf"]["name"])
    if not tg:
        new_tg = create_tg(elb_client, tg_conf, vpc_id)[0]
        tg_arn = new_tg["TargetGroupArn"]
        listener_conf = deploy_config["listener_conf"]
        create_listener(elb_client, listener_conf, tg_arn, lb_arn)
        tg = new_tg

    
    tpl_conf = deploy_config["tpl_conf"]
    tpls = get_launch_tpls(ec2_client, tpl_conf["name"])

    tpl = None
    tpl_num_id = 1
    tpl_old_num_id = 0

    if len(tpls) > 0:
        tpl_old_num_id = get_max_id(tpls, "LaunchTemplateName")
        tpl_num_id = tpl_old_num_id + 1

    tpl_name = tpl_conf["name"] + f"_{tpl_num_id}"

    asgs = get_asg(asg_client, asg_conf["name"])

    asg_num_id = 1
    asg_old_num_id = 0

    if len(asgs) > 0:
        asg_old_num_id = get_max_id(asgs, "AutoScalingGroupName")
        asg_num_id = asg_old_num_id + 1

    old_total_count, old_healthy_count, old_targets = get_target_instances(check_target_health(elb_client, tg["TargetGroupArn"]))

    asg_name = asg_conf["name"] + f"_{asg_num_id}"

    tpl = create_launch_tpl(ec2_client, tpl_name, tpl_conf, sgs)
    tpl_id = tpl["LaunchTemplateId"]

    asgs = create_asg(asg_client, tpl_id, tg["TargetGroupArn"], asg_name, asg_conf, subnets)
    while True:
        targets = check_target_health(elb_client, tg["TargetGroupArn"])
        tc, hc, new_targets = get_target_instances(targets)
        if hc >= old_healthy_count + asg_conf["desired_capacity"]:
            print("deploy is success")
            break
        else:
            print(f"total: {tc}, old_healthy: {old_healthy_count}, current_healthy_count: {hc}") 

        time.sleep(5)

    targets = check_target_health(elb_client, tg["TargetGroupArn"])
    new_tc, new_hc, new_targets = get_target_instances(targets)

    old_asg_name = asg_conf["name"] + f"_{asg_old_num_id}"
    set_desired_capacity_as_zero(asg_client, old_asg_name)

    # Delete ASG
    while True:
        asg = get_asg(asg_client, old_asg_name)[0]
        size = len(asg["Instances"])
        if size == 0:
            print(f"old asg {old_asg_name} has no Instance")
            delete_asg(asg_client, old_asg_name)
            old_tpl_name = tpl_conf["name"] + f"_{tpl_old_num_id}"
            delete_launch_tpl(ec2_client, old_tpl_name)
            break
        else:
            print(f"old asg {old_asg_name} has {size} Instances")
            print(asg["Instances"])
            

        time.sleep(5)


conf = read_config(sys.argv[1])
for deploy_config in conf:
    deploy(deploy_config)
