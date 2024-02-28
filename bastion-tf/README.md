<details><summary><b> Using SSH-AGENT instead of copying private key </b></summary>
An SSH agent is a program that keeps track of user’s identity keys and their pass phrases and can be configured with the following commands:

#### Generate SSH keys
```ssh-keygen mykeypair```
#### Add the keys to your keychain
```ssh-add  mykeypair```
Once the keys have been generated and added to the keychain, it is possible to connect to the bastion instance with SSH using the -A option. This enables forwarding and lets the local agent respond to the public-key challenge when connecting to instances from your bastion.

#### Connect to the bastion host:
```ssh -A <bastion-ip-address>```
</details>
<details><summary><b> SSH authentication agent does not automatically start when using it from a remote server. This result in the following error message:</b></summary>

    $ ssh-add ~/my-ssh-key.pem
    Could not open a connection to your authentication agent.
    
To fix it requires manually starting ssh-agent:

    $ eval `ssh-agent -s`
    Agent pid 13442
    $ ssh-add ~/my-ssh-key.pem
    Identity added: /home/user/my-ssh-key.pem (/home/user/my-ssh-key.pem)

</details>	
	
### This terraform code will create  bastion host on AWS 

![bastion_host](https://user-images.githubusercontent.com/100177153/156974704-4edc013e-e845-44f1-aa9b-915856723692.jpg)

### Create VPC Infrastructure
```
10.0.0.0/16 - vpc
private subnet a - 10.0.12.0/24 - nat-A 
private subnet b - 10.0.22.0/24 - nat-B
public subnet a  - 10.0.11.0/24 - igw
public subnet b - 10.0.21.0/24  - igw
db subnet a - 10.0.13.0/24
db subnet b- 10.0.23.0/24
route table public 
route table private a - (subnet associate private subnet a)
route table private b -  (subnet associate private subnet b)
route table db - (subnet associate db-a and db-b)
nat -a - elastic ip attached 
nat -b - elastic ip attached 
nat-a attached to public subnet a  - destination 0.0.0.0/0
nat-b attached to public subnet b - destination 0.0.0.0/0
```
### BASTION Host

Bastion host is atatched to ASG.

sec group (SSH-Access-For-Bastion) - inbound rules open ssh 22 port anywhere   0.0.0.0/0  (outbond nothing)
asg launch configuration (Bastion_Host)
asg  (Bastion_ASG)

	1. asg will automatically create bastion host 

	2. create ec2 instance for bastion host
	  - attach PrivateSubnet-A
	  - auto-assign Public IP - No
	  - sec group (SSH-Access-For-Bastion)

	3. create another ec2 instance for bastion host DB
	  - attach DBSubnet-B
	  - auto-assign Public IP - No
    - sec group (SSH-Access-For-Bastion)





(c) Sahib Gasimov
