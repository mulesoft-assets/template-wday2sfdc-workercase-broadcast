%dw 1.0
%output application/java

%var idValue = flowVars.uniqueId
//generateUniqueIdFromName("Bruce_")
--- 
{
	version: 'v20',
	businessProcessParameters : {
		autoComplete : true
	},
	hireEmployeeData : {
		applicantData: {
			externalIntegrationIDData: {
				ID: [{
					systemID	: 'Jobvite',
				    value		: idValue
				    }]
			},
			personalData: {
				contactData: {
					addressData: [{
						addressLineData: [{
							type	: 'ADDRESS_LINE_1',
							value	: "999 Main St"

						}],
						countryReference: {
							ID: [{
								type	: 'ISO_3166-1_Alpha-3_Code',
								value	: "USA"
							}]
						},
						countryRegionReference: {
							ID: [{
								type	: 'Country_Region_ID',
								value	: "USA-CA"
							}]
						},
						effectiveDate	: now,
						municipality 	: "San Francisco",
						postalCode 		: "94105",
						usageData: [{
							typeData:[{
								primary : true,
								typeReference: {
									ID: [{
										type	: 'Communication_Usage_Type_ID',
										value	: 'HOME'
									}]
								}
							}]
						}]
					}],
					emailAddressData 	: [{
						emailAddress	: p('test.wday.email'),
						usageData: [{
							public: true,
							typeData: [{
								primary: true,
								typeReference: {
									ID: [{
										type	: 'Communication_Usage_Type_ID',
										value	: 'HOME'
									}]
								}
							}]
						}]
					}],
					phoneData: [{
						internationalPhoneCode: '1',
						phoneDeviceTypeReference: {
							ID: [{
								type	: 'Phone_Device_Type_ID',
								value	: '1063.5'
							}]
						},
						phoneNumber		: "650-232-2323",
						usageData: [{
							public: true,
							typeData: [{
								primary: true,
								typeReference: {
									ID: [{
										type	: 'Communication_Usage_Type_ID',
										value	: 'HOME'
									}]
								}
							}]
						}]
					}]
				},
				nameData: {
					legalNameData: {
						nameDetailData: {
							countryReference: {
								ID: [{
									type	: 'ISO_3166-1_Alpha-3_Code',
									value	: "USA"
								}]
							},
							firstName	: idValue,
							lastName	: p('test.wday.family.name')
						}
					}
				}
			}
		},	
			hireDate: now,
			hireEmployeeEventData: {
				employeeExternalIDData: {
					externalID: [{
						externalID: idValue,
						systemID: 'Salesforce - Chatter'
					}]
				},
				employeeTypeReference: {
			        ID: [{
			            type: 'Employee_Type_ID',
			            value: 'Regular'
			        }]
			    },
			    firstDayOfWork: now,
			    hireReasonReference: {
			    	ID: [{
			    		type	: 'General_Event_Subcategory_ID',
			    		value	: 'Hire_Employee_New_Hire_Fill_Vacancy'
			    	}]
			    },
			    positionDetails: {
			    	positionTitle: "QA Engineer",
			    	defaultHours: 40,
			    	scheduledHours: 40,
			    	jobProfileReference: {
			    		ID: [{
			    			type: 'Job_Profile_ID',
			    			value: "39905"
			    		}]
			    	},
			    	locationReference: {
			    		ID: [{
			    			type: 'Location_ID',
			    			value: "San_Francisco_site"
			    		}]
			    	},
			    	payRateTypeReference : {
			    		ID : [{
			    			type: 'Pay_Rate_Type_ID',
			    			value: "Salary"
			    		}]
			    	},
			    	positionTimeTypeReference : {
			    		ID : [{
			    			type: 'Position_Time_Type_ID',
			    			value: "Full_Time"
			    		}]
			    	}
			    }
			},
			organizationReference: {
				ID: [{
					type: 'Organization_Reference_ID',
					value: '50006855'
				}]
			},
			proposeCompensationForHireSubProcess: {
				businessSubProcessParameters : {
					autoComplete : true
				},
				proposeCompensationForHireData : {
					compensationGuidelinesData : {
						compensationGradeReference : {
							ID: [{
								type: 'Compensation_Grade_ID',
								value: 'Non_Management'
							}]
						},
						compensationPackageReference : {
							ID : [{
								type : 'Compensation_Package_ID',
								value: 'Non_Management_Compensation_Package'
							}]
						}
					},
				payPlanData: {
					payPlanSubData: [{
						amount: "140000",
						currencyReference : {
							ID : [{
								type: 'Currency_ID',
								value: "USD"
							}]
						},
						frequencyReference : {
							ID: [{
								type : 'Frequency_ID',
								value : "Annual"
							}]
						},
						payPlanReference : {
							ID : [{
								type : 'Compensation_Plan_ID',
								value: "SALARY_Salary_Plan"
							}]
						}
					}],
					'replace' : false
				},
				primaryCompensationBasis : "140000"
				}
			}
		}
	
	
} as :object {class: "com.workday.staffing.HireEmployeeRequestType"}