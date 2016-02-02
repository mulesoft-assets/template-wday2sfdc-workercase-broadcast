%dw 1.0
%output application/xml
%namespace ns0 urn:com.workday/bsvc

%var idValue = flowVars.uniqueId
//generateUniqueIdFromName("Bruce_")
---
{
	ns0#Hire_Employee_Request: {
		ns0#Business_Process_Parameters: {
			ns0#Auto_Complete: true
		},
		ns0#Hire_Employee_Data: {
			ns0#Applicant_Data: {
				ns0#Personal_Data: {
					ns0#Name_Data: {
						ns0#Legal_Name_Data: {
							ns0#Name_Detail_Data: {
								ns0#Country_Reference: {
									ns0#ID @(ns0#type: 'ISO_3166-1_Alpha-3_Code'): "USA"
								},
								ns0#First_Name: idValue,
								ns0#Last_Name: p('test.wday.family.name')
							}
						}
					},
					ns0#Contact_Data: {
						ns0#Address_Data: {
							ns0#Country_Reference: {
								ns0#ID @(ns0#type: 'ISO_3166-1_Alpha-3_Code'): "USA"
							},
							ns0#Address_Line_Data @(ns0#Type: 'ADDRESS_LINE_1'): "999 Main St",
							ns0#Municipality: "San Francisco",
							ns0#Country_Region_Reference: {
								ns0#ID @(ns0#type: 'Country_Region_ID'): "USA-CA"
							},
							ns0#Postal_Code: "94105",
							ns0#Usage_Data: {
								ns0#Type_Data @(ns0#Primary: true): {
									ns0#Type_Reference: {
										ns0#ID @(ns0#type: 'Communication_Usage_Type_ID'): 'HOME'
									}
								}
							}
						},
						ns0#Phone_Data: {
							ns0#International_Phone_Code: '1',
							ns0#Phone_Number: "650-232-2323",
							ns0#Phone_Device_Type_Reference: {
								ns0#ID @(ns0#type: 'Phone_Device_Type_ID'): '1063.5'
							},
							ns0#Usage_Data @(ns0#Public: true): {
								ns0#Type_Data @(ns0#Primary: true): {
									ns0#Type_Reference: {
										ns0#ID @(ns0#type: 'Communication_Usage_Type_ID'): 'HOME'
									}
								}
							}
						},
						ns0#Email_Address_Data: {
							ns0#Email_Address: p('test.wday.email'),
							ns0#Usage_Data @(ns0#Public: true): {
								ns0#Type_Data @(ns0#Primary: true): {
									ns0#Type_Reference: {
										ns0#ID @(ns0#type: 'Communication_Usage_Type_ID'): 'HOME'
									}
								}
							}
						}
					}
				},
				ns0#External_Integration_ID_Data: {
					ns0#ID @(ns0#System_ID: 'Jobvite'): idValue
				}
			},
			ns0#Organization_Reference: {
				ns0#ID @(ns0#type: 'Organization_Reference_ID'): '50006855'
			},
			ns0#Hire_Date: now,
			ns0#Hire_Employee_Event_Data: {
				ns0#Hire_Reason_Reference: {
					ns0#ID @(ns0#type: 'General_Event_Subcategory_ID'): 'Hire_Employee_New_Hire_Fill_Vacancy'
				},
				ns0#Employee_Type_Reference: {
					ns0#ID @(ns0#type: 'Employee_Type_ID'): 'Regular'
				},
				ns0#First_Day_of_Work: now,
				ns0#Position_Details: {
					ns0#Job_Profile_Reference: {
						ns0#ID @(ns0#type: 'Job_Profile_ID'): "39905"
					},
					ns0#Position_Title: "QA Engineer",
					ns0#Location_Reference: {
						ns0#ID @(ns0#type: 'Location_ID'): "San_Francisco_site"
					},
					ns0#Position_Time_Type_Reference: {
						ns0#ID @(ns0#type: 'Position_Time_Type_ID'): "Full_Time"
					},
					ns0#Default_Hours: 40,
					ns0#Scheduled_Hours: 40,
					ns0#Pay_Rate_Type_Reference: {
						ns0#ID @(ns0#type: 'Pay_Rate_Type_ID'): "Salary"
					}
				},
				ns0#Employee_External_ID_Data: {
					ns0#External_ID @(ns0#System_ID: 'Salesforce - Chatter'): {
						ns0#External_ID: idValue
					}
				}
			},
			ns0#Propose_Compensation_for_Hire_Sub_Process: {
				ns0#Business_Sub_Process_Parameters: {
					ns0#Auto_Complete: true
				},
				ns0#Propose_Compensation_for_Hire_Data: {
					ns0#Primary_Compensation_Basis: "140000",
					ns0#Compensation_Guidelines_Data: {
						ns0#Compensation_Package_Reference: {
							ns0#ID @(ns0#type: 'Compensation_Package_ID'): 'Non_Management_Compensation_Package'
						},
						ns0#Compensation_Grade_Reference: {
							ns0#ID @(ns0#type: 'Compensation_Grade_ID'): 'Non_Management'
						}
					},
					ns0#Pay_Plan_Data @(ns0#Replace: false): {
						ns0#Pay_Plan_Sub_Data: {
							ns0#Pay_Plan_Reference: {
								ns0#ID @(ns0#type: 'Compensation_Plan_ID'): "SALARY_Salary_Plan"
							},
							ns0#Amount: "140000",
							ns0#Currency_Reference: {
								ns0#ID @(ns0#type: 'Currency_ID'): "USD"
							},
							ns0#Frequency_Reference: {
								ns0#ID @(ns0#type: 'Frequency_ID'): "Annual"
							}
						}
					}
				}
			}
		}
	}
}