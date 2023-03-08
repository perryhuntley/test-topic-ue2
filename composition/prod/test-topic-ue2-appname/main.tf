module "map" {
    source 											= "git@git.signintra.com:dct/azure/terraform-subscription-static.git"
}		
		
module "call_module" {		
    source                                  		= "git@git.signintra.com:dct/azure/terraform-azurerm-vm-v2.git"
		
    # IDENTITY RELATED VARIABLES		
    topic                                   		= var.topic                                                     # Required - Topic Name
    stage                                   		= var.stage                                                     # Required - Stage Name
    application                             		= var.application                                               # Required - Application Name
    task                                    		= var.task                                                      # Optional - Task Name
    location                                		= var.location                                                  # Required - Target Location
    heritage                                		= var.topic                                                     # Required - Heritage (GIT Repo - HTTPS URL)
    contact                                 		= var.contact                               					# Required - Contact Email ID of Topic Owner
    costcenter                              		= var.costcenter                                                # Required - Cost Center
    executionitem                           		= var.executionitem                                             # Required - Execution Item
    operatedby                              		= var.operatedby                                                # Required - Operated by (GPO or IMO)
    custom_tags                             		= var.custom_tags                                               # Optional - Custom Tags, if any		

    # GENERAL VARIABLES		
    use_default_naming                      		= var.use_default_naming                                        # Optional - Flag to set Default Naming. Defaults to true
    network_type                            		= var.network_type                                              # Required - Vnet type e.g. hub or spoke
    topic_rg_name                           		= data.azurerm_resource_group.topic_rg.name                     # Required - Name of the Resource Group for Topic
		
    # VIRTUAL MACHINE RELATED VARIABLES		
    vm_count                                		= var.vm_count                                                  # Required - Count of Virtual Machine to be created. Must be equal to number of both 'vm_config' and 'nic_config' blocks provided within the list object and no of elements in 'public_ip_enabled' list object
    vm_os                                   		= var.vm_os                                                     # Required - OS Type of Virtual Machine(s)
    vm_config                               		= [                                                             # Required - List of Virtual Machine configuration blocks. The number of 'vm_config' blocks provided within the list object must be equal to the value of 'vm_count'
    {
        "01"                                       	= {
            # name                                 	= ""
            size                                   	= var.vm_sizes["4vCPU-16GB"]
            wwwcomputer_name                        = "vm1computer"
            zone                                    = "1"
            os_disk                                	= {
                size_gb                            	= 128
                type                               	= "Premium_LRS"
            }
            data_disk                              	= {
                "01"                               	= {
                    # name                         	= "datadisk1name"
                    type                           	= "Premium_LRS"
                    create_option                  	= "Empty"
                    size_gb                        	= 128
                    # source_resource_id           	= ""
                    # lun                          	= "25"
                    caching                        	= "None"
                }	
                # "02"                               	= {
                #     name                           	= "datadisk2name"
                #     # type                         	= "Premium_LRS"
                #     create_option                  	= "Empty"
                #     size_gb                        	= 123
                #     # source_resource_id           	= ""
                #     # lun                          	= "20"
                #     caching                        	= "None"
                # }	
            }               
            backup_enabled                         	= true
            backup_policy                          	= "${var.backup_plans["ShortTerm(1month)-21:00-24:00"]}-${upper(module.map.region_map[var.location])}"
            Backupwindow                           	= var.backup_plans["ShortTerm(1month)-21:00-24:00"]
            chefclient_enabled                     	= true
            chef_policy_name                       	= "azure-basic"
            patching_schedule                       = "Windows-Prod-3sun-03_00-06_00-${upper(module.map.region_map[var.location])}"
        }	
    # },	
    # {	
    #     "02"                                       	= {
    #         name                                   	= "vm2"
    #         size                                   	= var.vm_sizes["2vCPU-8GB"]
    #         computer_name                          	= "vm2computername"
    #         patching_schedule                      	= "Windows-NonProd-3wed-03_00-06_00-${upper(module.map.region_map[var.location])}"
    #         os_disk                                	= {
    #             name                               	= "vm2os"
    #             size_gb                            	= 2433
    #             caching                            	= "None"
    #             type                               	= "Standard_LRS"
    #         }	
    #         data_disk                              	= {
    #             "01"                               	= {
    #                 # name                         	= "vm2data1"
    #                 type                           	= "Standard_LRS"
    #                 create_option                  	= "Empty"
    #                 size_gb                        	= 123
    #                 # source_resource_id           	= ""
    #                 # lun                          	= "25"
    #                 caching                        	= "None"
    #             }	
    #             "02"                               	= {
    #                 name                           	= "vm2data2"
    #                 # type                         	= "Premium_LRS"
    #                 create_option                  	= "Empty"
    #                 size_gb                        	= 123
    #                 # source_resource_id           	= ""
    #                 # lun                          	= "20"
    #                 caching                        	= "None"
    #             }	
    #         }	
    #     }	
    # },	
    # {	
    #     "03"                                       	= {
    #         name                                   	= "vm3"
    #         size                                   	= var.vm_sizes["2vCPU-8GB"]
    #         computer_name                          	= "vm3computername"
    #         patching_schedule                      	= "Windows-NonProd-3wed-03_00-06_00-${upper(module.map.region_map[var.location])}"
    #         os_disk                                	= {
    #             name                               	= "vm3os"
    #             size_gb                            	= 128
    #             caching                            	= "None"
    #             type                               	= "Premium_LRS"
    #         }	
    #         data_disk                              	= {
    #             "01"                               	= {
    #                 # name                         	= "vm3data1"
    #                 type                           	= "Standard_LRS"
    #                 create_option                  	= "Empty"
    #                 size_gb                        	= 123
    #                 # source_resource_id           	= ""
    #                 # lun                          	= "25"
    #                 caching                        	= "None"
    #             }
    #         }
    #     }
    }
    ]
    # key_vault_name                       		 	= ""                                                            # Optional - Keyvault name to store the VM Password/Key. Required if 'default_key_vault_name' is not provided
    # key_vault_rg                         		 	= ""                                                            # Optional - Keyvault's Resource Group Name. Required if 'default_key_vault_resource_group_name' is not provided
    default_key_vault_name                 		 	= local.default_key_vault_name                                  # Optional - Default Keyvault name to store the VM Password/Key. Required if 'key_vault_name' is not provided
    default_key_vault_resource_group_name  		 	= local.default_key_vault_resource_group_name                   # Optional - Default Keyvault's Resource Group Name. Required if 'key_vault_rg' is not provided
    # vm_image_publisher                   		 	= ""                                                            # Optional - Publisher of the image used to create the virtual machines. Required if 'source_image_id' is not provided
    # vm_image_offer                       		 	= ""                                                            # Optional - Offer of the image used to create the virtual machines. Required if 'source_image_id' is not provided
    # vm_image_sku                         		 	= ""                                                            # Optional - SKU of the image used to create the virtual machines. Required if 'source_image_id' is not provided
    # vm_image_version                     		 	= ""                                                            # Optional - Version of the image used to create the virtual machines. Required if 'source_image_id' is not provided
    source_image_id                                 = "dbschenker-win19/versions/2022.10.24" #p for win16, win19, ubuntu18, ubuntu20, rhel7, rhel8"
    # disk_encryption_set_id                 		= ""                                                            # Optional - Resource ID of the Disk Encryption Set to be used for encryption, used default if blank; set to override
    diagnostics_storage_account_uri        		 	= local.diag_storage_account                                    # Required - URI of the Diagnostice Storage Account to be used

    # NETWORK INTERFACE RELATED VARIABLES
    subnet                                  		= var.subnet_type                                               # Required - Identifier for the Subnet to be used. Allowed values are 'dmz', 'edge', 'app', 'data'
    nic_config                              		= [                                                             # Required - List of Network Interfaces configuration blocks. The number of 'nic_config' blocks provided within the list object must be equal to the value of 'vm_count'
    {
        "01"                                       	= {
            
            ip_config                              	= [
            {	
                instance                           	= "01"
                private_ip_address_allocation      	= "Dynamic"
                
            },	
            # {	
            #     instance                           	= "02"
            #     private_ip_address_allocation      	= "Dynamic"
            #     #private_ip_address                	= "10.228.136.253"
            #     primary                            	= false
            #     public_ip_allocation_method        	= "Static"
            # },	
            ]	
        }	
        # "02"                                       	= {
        #     name                                   	= "vm1nic2"
        #     ip_config                              	= [
        #     {	
        #         instance                           	= "01"
        #         private_ip_address_allocation      	= "Dynamic"
        #         public_ip_allocation_method        	= "Static"
        #     },	
        #     ]	
        # }	
    },	
    # {	
    #     "01"                                       	= {
    #         name                                   	= "vm2nic1"
    #         ip_config                              	= [
    #         {	
    #             instance                           	= "01"
    #             private_ip_address_allocation      	= "Dynamic"
    #             public_ip_name                     	= "testtest-pip"
    #             public_ip_allocation_method        	= "Static"
    #         },	
    #         ]	
    #     }	
    # },	
    # {	
    #     "01"                                       	= {
    #         name                                   	= "vm3nic1"
    #         ip_config                              	= [
    #         {	
    #             instance                           	= "01"
    #             private_ip_address_allocation      	= "Dynamic"
    #             # public_ip_name                   	= "testtest-pip"
    #             # public_ip_allocation_method      	= "Static"
    #         },
    #         ]
    #     }
    # }
    ]
    public_ip_enabled                       		= [false]                          # Required - List of boolean Flag values to set if Public IP is Enabled on NIC level. The number of values provided must be equal to the value of 'vm_count'
    dns_servers                             		= []                                                            # Optional - A list of IP Addresses defining the DNS Servers which should be used for this Network Interface
		
    # GRAFANA DASHBOARD RELATED VARIABLES		
    grafana_enabled                         		= var.grafana_enabled                                           # Optional - Flag to enable Grafana Dashboard for the VM. Defaults to false
    grafana_folder_id                       		= data.grafana_folder.topic[0].id                                  # Optional - Grafana Folder ID
    grafana_notification_uid                		= data.azurerm_key_vault_secret.grafana_notification_uid[0].value  # Optional - Grafana Notification UID
		
    # CHEF RELATED VARIABLES		
    chef_validation_key                     		= data.azurerm_key_vault_secret.chef_validation_key.value       # Required - Chef Validation Key

    # NETWORK SECURITY GROUP RELATED VARIABLES
    # addtional_nsg_rules                     		= [                                                             # Optional - Custom / Additional NSG rules block
    # {
    #     name                                       	= "Allowed1"
    #     priority                                   	= "130"
    #     direction                                  	= "Inbound"
    #     access                                     	= "Allow"
    #     protocol                                   	= "Tcp"
    #     destination_port_range                     	= "135, 445, 23, 80, 139"
    #     source_type                                	= "address_prefixes"
    #     source_address_prefixes                    	= ["10.213.0.0/16"]
    #     destination_type                           	= "application_security_group"
    #     # destination_address_prefixes             	= ["10.0.0.0/8"]
    # },	
    # {	
    #     name                                       	= "Allowed2"
    #     priority                                   	= "131"
    #     direction                                  	= "Inbound"
    #     access                                     	= "Allow"
    #     protocol                                   	= "Tcp"
    #     destination_port_range                     	= "443"
    #     source_type                                	= "address_prefixes"
    #     source_address_prefixes                    	= ["10.213.0.0/16"]
    #     destination_type                           	= "address_prefixes"
    #     destination_address_prefixes               	= ["10.0.0.0/8"]
    # }	
    # ]	
    # predefined_nsg_rules                    		= [    	                                                         # Optional - Predefined NSG rules block
    # {	
    #     name                                       	= "Cassandra"
    #     priority                                   	= 400
    # },	
    # {	
    #     name                                       	= "ActiveDirectory-AllowADReplication"
    #     priority                                   	= 401
    # }	
    # ]	
	
    # APPLICATION SECURITY GROUP RELATED VARIABLES	
    asg_id                                         	= data.azurerm_application_security_group.topic_asg.id   		 # Required - Resource ID of the existing ASG
}
