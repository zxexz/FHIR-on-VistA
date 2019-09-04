SYNDHP30C ; HC/art - HealthConcourse - continuation of get Pharmacy Patient data ;08/29/2019
 ;;1.0;DHP;;Jan 17, 2017
 ;;
 ;;Original routine authored by Andrew Thompson & Ferdinand Frankson of Perspecta 2017-2019
 ;
 QUIT
 ;
PHCONT3 ;
 ;
 N IENS11 S IENS11=""
 F  S IENS11=$O(PHPATARR(FNBR11,IENS11)) QUIT:IENS11=""  D
 . N IVS S IVS=$NA(PHPAT("Phpat","ivs","iv",+IENS11))
 . S @IVS@("orderNumber")=$G(PHPATARR(FNBR11,IENS11,.01,"E"))
 . S @IVS@("startDateTime")=$G(PHPATARR(FNBR11,IENS11,.02,"E"))
 . S @IVS@("startDateTimeFM")=$G(PHPATARR(FNBR11,IENS11,.02,"I"))
 . S @IVS@("startDateTimeHL7")=$$FMTHL7^XLFDT($G(PHPATARR(FNBR11,IENS11,.02,"I")))
 . S @IVS@("startDateTimeFHIR")=$$FMTFHIR^SYNDHPUTL($G(PHPATARR(FNBR11,IENS11,.02,"I")))
 . S @IVS@("stopDateTime")=$G(PHPATARR(FNBR11,IENS11,.03,"E"))
 . S @IVS@("stopDateTimeFM")=$G(PHPATARR(FNBR11,IENS11,.03,"I"))
 . S @IVS@("stopDateTimeHL7")=$$FMTHL7^XLFDT($G(PHPATARR(FNBR11,IENS11,.03,"I")))
 . S @IVS@("stopDateTimeFHIR")=$$FMTFHIR^SYNDHPUTL($G(PHPATARR(FNBR11,IENS11,.03,"I")))
 . S @IVS@("type")=$G(PHPATARR(FNBR11,IENS11,.04,"E"))
 . S @IVS@("typeCd")=$G(PHPATARR(FNBR11,IENS11,.04,"I"))
 . S @IVS@("provider")=$G(PHPATARR(FNBR11,IENS11,.06,"E"))
 . S @IVS@("providerId")=$G(PHPATARR(FNBR11,IENS11,.06,"I"))
 . S @IVS@("providerNPI")=$$GET1^DIQ(200,@IVS@("providerId")_",",41.99) ;NPI
 . S @IVS@("providerResId")=$$RESID^SYNDHP69("V",SITE,200,@IVS@("providerId"))
 . S @IVS@("infusionRate")=$G(PHPATARR(FNBR11,IENS11,.08,"E"))
 . S @IVS@("schedule")=$G(PHPATARR(FNBR11,IENS11,.09,"E"))
 . S @IVS@("remarks")=$G(PHPATARR(FNBR11,IENS11,.1,"E"))
 . S @IVS@("administrationTimes")=$G(PHPATARR(FNBR11,IENS11,.12,"E"))
 . S @IVS@("lastFill")=$G(PHPATARR(FNBR11,IENS11,.15,"E"))
 . S @IVS@("lastFillFM")=$G(PHPATARR(FNBR11,IENS11,.15,"I"))
 . S @IVS@("lastFillHL7")=$$FMTHL7^XLFDT($G(PHPATARR(FNBR11,IENS11,.15,"I")))
 . S @IVS@("lastFillFHIR")=$$FMTFHIR^SYNDHPUTL($G(PHPATARR(FNBR11,IENS11,.15,"I")))
 . S @IVS@("lastQtyFilled")=$G(PHPATARR(FNBR11,IENS11,.16,"E"))
 . S @IVS@("scheduleInterval")=$G(PHPATARR(FNBR11,IENS11,.17,"E"))
 . S @IVS@("loginDateTime")=$G(PHPATARR(FNBR11,IENS11,.21,"E"))
 . S @IVS@("loginDateTimeFM")=$G(PHPATARR(FNBR11,IENS11,.21,"I"))
 . S @IVS@("loginDateTimeHL7")=$$FMTHL7^XLFDT($G(PHPATARR(FNBR11,IENS11,.21,"I")))
 . S @IVS@("loginDateTimeFHIR")=$$FMTFHIR^SYNDHPUTL($G(PHPATARR(FNBR11,IENS11,.21,"I")))
 . S @IVS@("ivRoom")=$G(PHPATARR(FNBR11,IENS11,.22,"E"))
 . S @IVS@("ivRoomId")=$G(PHPATARR(FNBR11,IENS11,.22,"I"))
 . S @IVS@("cumulativeDoses")=$G(PHPATARR(FNBR11,IENS11,.24,"E"))
 . S @IVS@("originalWard")=$G(PHPATARR(FNBR11,IENS11,9,"E"))
 . S @IVS@("originalWardId")=$G(PHPATARR(FNBR11,IENS11,9,"I"))
 . S @IVS@("verifyingNurse")=$G(PHPATARR(FNBR11,IENS11,16,"E"))
 . S @IVS@("verifyingNurseId")=$G(PHPATARR(FNBR11,IENS11,16,"I"))
 . S @IVS@("dateVerifiedByNurse")=$G(PHPATARR(FNBR11,IENS11,17,"E"))
 . S @IVS@("dateVerifiedByNurseFM")=$G(PHPATARR(FNBR11,IENS11,17,"I"))
 . S @IVS@("dateVerifiedByNurseHL7")=$$FMTHL7^XLFDT($G(PHPATARR(FNBR11,IENS11,17,"I")))
 . S @IVS@("dateVerifiedByNurseFHIR")=$$FMTFHIR^SYNDHPUTL($G(PHPATARR(FNBR11,IENS11,17,"I")))
 . S @IVS@("otherPrintInfo")=$G(PHPATARR(FNBR11,IENS11,31,"E"))
 . S @IVS@("status")=$G(PHPATARR(FNBR11,IENS11,100,"E"))
 . S @IVS@("statusCd")=$G(PHPATARR(FNBR11,IENS11,100,"I"))
 . S @IVS@("ward")=$G(PHPATARR(FNBR11,IENS11,104,"E"))
 . S @IVS@("totalIvSAdministered")=$G(PHPATARR(FNBR11,IENS11,105,"E"))
 . S @IVS@("chemotherapyType")=$G(PHPATARR(FNBR11,IENS11,106,"E"))
 . S @IVS@("chemotherapyTypeCd")=$G(PHPATARR(FNBR11,IENS11,106,"I"))
 . S @IVS@("syringeSize")=$G(PHPATARR(FNBR11,IENS11,107,"E"))
 . S @IVS@("intermittentSyringe")=$G(PHPATARR(FNBR11,IENS11,108,"E"))
 . S @IVS@("intermittentSyringeCd")=$G(PHPATARR(FNBR11,IENS11,108,"I"))
 . S @IVS@("dcDate")=$G(PHPATARR(FNBR11,IENS11,109,"E"))
 . S @IVS@("dcDateFM")=$G(PHPATARR(FNBR11,IENS11,109,"I"))
 . S @IVS@("dcDateHL7")=$$FMTHL7^XLFDT($G(PHPATARR(FNBR11,IENS11,109,"I")))
 . S @IVS@("dcDateFHIR")=$$FMTFHIR^SYNDHPUTL($G(PHPATARR(FNBR11,IENS11,109,"I")))
 . S @IVS@("ordersFileEntry")=$G(PHPATARR(FNBR11,IENS11,110,"E"))
 . S @IVS@("atzero")=$G(PHPATARR(FNBR11,IENS11,112,"E"))
 . S @IVS@("atzeroCd")=$G(PHPATARR(FNBR11,IENS11,112,"I"))
 . S @IVS@("previousOrder")=$G(PHPATARR(FNBR11,IENS11,113,"E"))
 . S @IVS@("followingOrder")=$G(PHPATARR(FNBR11,IENS11,114,"E"))
 . S @IVS@("providerComments")=""
 . N Z S Z=""
 . F  S Z=$O(PHPATARR(FNBR11,IENS11,115,Z)) QUIT:'+Z  D
 . . S @IVS@("providerComments")=@IVS@("providerComments")_$G(PHPATARR(FNBR11,IENS11,115,Z))
 . S @IVS@("originalStopDate")=$G(PHPATARR(FNBR11,IENS11,116,"E"))
 . S @IVS@("originalStopDateFM")=$G(PHPATARR(FNBR11,IENS11,116,"I"))
 . S @IVS@("originalStopDateHL7")=$$FMTHL7^XLFDT($G(PHPATARR(FNBR11,IENS11,116,"I")))
 . S @IVS@("originalStopDateFHIR")=$$FMTFHIR^SYNDHPUTL($G(PHPATARR(FNBR11,IENS11,116,"I")))
 . S @IVS@("oerrHoldFlag")=$G(PHPATARR(FNBR11,IENS11,120,"E"))
 . S @IVS@("oerrHoldFlagCd")=$G(PHPATARR(FNBR11,IENS11,120,"I"))
 . S @IVS@("autoDc")=$G(PHPATARR(FNBR11,IENS11,121,"E"))
 . S @IVS@("autoDcCd")=$G(PHPATARR(FNBR11,IENS11,121,"I"))
 . S @IVS@("reasonOrderCreated")=$G(PHPATARR(FNBR11,IENS11,122,"E"))
 . S @IVS@("reasonOrderCreatedCd")=$G(PHPATARR(FNBR11,IENS11,122,"I"))
 . S @IVS@("reasonForFollowingOrder")=$G(PHPATARR(FNBR11,IENS11,123,"E"))
 . S @IVS@("reasonForFollowingOrderCd")=$G(PHPATARR(FNBR11,IENS11,123,"I"))
 . S @IVS@("marLabelDate")=$G(PHPATARR(FNBR11,IENS11,128,"E"))
 . S @IVS@("marLabelDateFM")=$G(PHPATARR(FNBR11,IENS11,128,"I"))
 . S @IVS@("marLabelDateHL7")=$$FMTHL7^XLFDT($G(PHPATARR(FNBR11,IENS11,128,"I")))
 . S @IVS@("marLabelDateFHIR")=$$FMTFHIR^SYNDHPUTL($G(PHPATARR(FNBR11,IENS11,128,"I")))
 . S @IVS@("marLabelReason")=$G(PHPATARR(FNBR11,IENS11,129,"E"))
 . S @IVS@("marLabelReasonCd")=$G(PHPATARR(FNBR11,IENS11,129,"I"))
 . S @IVS@("orderableItem")=$G(PHPATARR(FNBR11,IENS11,130,"E"))
 . S @IVS@("orderableItemId")=$G(PHPATARR(FNBR11,IENS11,130,"I"))
 . S @IVS@("dosageOrdered")=$G(PHPATARR(FNBR11,IENS11,131,"E"))
 . S @IVS@("medRoute")=$G(PHPATARR(FNBR11,IENS11,132,"E"))
 . S @IVS@("medRouteId")=$G(PHPATARR(FNBR11,IENS11,132,"I"))
 . S @IVS@("instructions")=$G(PHPATARR(FNBR11,IENS11,133,"E"))
 . S @IVS@("priority")=$G(PHPATARR(FNBR11,IENS11,134,"E"))
 . S @IVS@("priorityCd")=$G(PHPATARR(FNBR11,IENS11,134,"I"))
 . S @IVS@("entryBy")=$G(PHPATARR(FNBR11,IENS11,135,"E"))
 . S @IVS@("entryById")=$G(PHPATARR(FNBR11,IENS11,135,"I"))
 . S @IVS@("entryByResId")=$$RESID^SYNDHP69("V",SITE,200,@IVS@("entryById"))
 . S @IVS@("clinic")=$G(PHPATARR(FNBR11,IENS11,136,"E"))
 . S @IVS@("clinicId")=$G(PHPATARR(FNBR11,IENS11,136,"I"))
 . S @IVS@("natureOfOrder")=$G(PHPATARR(FNBR11,IENS11,137,"E"))
 . S @IVS@("natureOfOrderCd")=$G(PHPATARR(FNBR11,IENS11,137,"I"))
 . S @IVS@("appointmentDateTime")=$G(PHPATARR(FNBR11,IENS11,139,"E"))
 . S @IVS@("appointmentDateTimeFM")=$G(PHPATARR(FNBR11,IENS11,139,"I"))
 . S @IVS@("appointmentDateTimeHL7")=$$FMTHL7^XLFDT($G(PHPATARR(FNBR11,IENS11,139,"I")))
 . S @IVS@("appointmentDateTimeFHIR")=$$FMTFHIR^SYNDHPUTL($G(PHPATARR(FNBR11,IENS11,139,"I")))
 . S @IVS@("verifyingPharmacist")=$G(PHPATARR(FNBR11,IENS11,140,"E"))
 . S @IVS@("verifyingPharmacistId")=$G(PHPATARR(FNBR11,IENS11,140,"I"))
 . S @IVS@("dateVerifiedByPharmacist")=$G(PHPATARR(FNBR11,IENS11,141,"E"))
 . S @IVS@("dateVerifiedByPharmacistFM")=$G(PHPATARR(FNBR11,IENS11,141,"I"))
 . S @IVS@("dateVerifiedByPharmacistHL7")=$$FMTHL7^XLFDT($G(PHPATARR(FNBR11,IENS11,141,"I")))
 . S @IVS@("dateVerifiedByPharmacistFHIR")=$$FMTFHIR^SYNDHPUTL($G(PHPATARR(FNBR11,IENS11,141,"I")))
 . S @IVS@("pvFlag")=$G(PHPATARR(FNBR11,IENS11,142,"E"))
 . S @IVS@("pvFlagCd")=$G(PHPATARR(FNBR11,IENS11,142,"I"))
 . S @IVS@("nvFlag")=$G(PHPATARR(FNBR11,IENS11,143,"E"))
 . S @IVS@("nvFlagCd")=$G(PHPATARR(FNBR11,IENS11,143,"I"))
 . S @IVS@("bcmaStatus")=$G(PHPATARR(FNBR11,IENS11,144,"E"))
 . S @IVS@("bcmaStatusCd")=$G(PHPATARR(FNBR11,IENS11,144,"I"))
 . S @IVS@("bcmaid")=$G(PHPATARR(FNBR11,IENS11,145,"E"))
 . S @IVS@("siOpiFlag")=$G(PHPATARR(FNBR11,IENS11,146,"E"))
 . S @IVS@("siOpiFlagCd")=$G(PHPATARR(FNBR11,IENS11,146,"I"))
 . S @IVS@("bcmaExpiredFlag")=$G(PHPATARR(FNBR11,IENS11,147,"E"))
 . S @IVS@("bcmaExpiredFlagCd")=$G(PHPATARR(FNBR11,IENS11,147,"I"))
 . S @IVS@("flagged")=$G(PHPATARR(FNBR11,IENS11,148,"E"))
 . S @IVS@("flaggedCd")=$G(PHPATARR(FNBR11,IENS11,148,"I"))
 . S @IVS@("holdFlag")=$G(PHPATARR(FNBR11,IENS11,149,"E"))
 . S @IVS@("holdFlagCd")=$G(PHPATARR(FNBR11,IENS11,149,"I"))
 . S @IVS@("ordersFileParentOrder")=$G(PHPATARR(FNBR11,IENS11,150,"E"))
 . S @IVS@("requestedDuration")=$G(PHPATARR(FNBR11,IENS11,151,"E"))
 . S @IVS@("requestedIvLimitation")=$G(PHPATARR(FNBR11,IENS11,152,"E"))
 . S @IVS@("otherPrintInfoLong")=""
 . N Z S Z=""
 . F  S Z=$O(PHPATARR(FNBR11,IENS11,154,Z)) QUIT:'+Z  D
 . . S @IVS@("otherPrintInfoLong")=@IVS@("otherPrintInfoLong")_$G(PHPATARR(FNBR11,IENS11,154,Z))
 . S @IVS@("labelsPerDay")=$G(PHPATARR(FNBR11,IENS11,155,"E"))
 . S @IVS@("displayStatus")=$G(PHPATARR(FNBR11,IENS11,157,"E"))
 . S @IVS@("displayStatusCd")=$G(PHPATARR(FNBR11,IENS11,157,"I"))
 . S @IVS@("resourceId")=$$RESID^SYNDHP69("V",SITE,FNBR1,PHPATIEN,FNBR11_U_+IENS11)
 ;
 N IENS12 S IENS12=""
 F  S IENS12=$O(PHPATARR(FNBR12,IENS12)) QUIT:IENS12=""  D
 . N IADD S IADD=$NA(PHPAT("Phpat","ivs","iv",$P(IENS12,C,2),"additives","additive",+IENS12))
 . S @IADD@("additive")=$G(PHPATARR(FNBR12,IENS12,.01,"E"))
 . S @IADD@("additiveId")=$G(PHPATARR(FNBR12,IENS12,.01,"I"))
 . S @IADD@("additiveName")=$$GET1^DIQ(52.6,@IADD@("additiveId")_",",1)
 . S @IADD@("additiveNameId")=$$GET1^DIQ(52.6,@IADD@("additiveId")_",",1,"I")
 . S @IADD@("additiveRxNorm")=$$GETRXN^SYNDHPUTL(@IADD@("additiveNameId"))
 . S @IADD@("strength")=$G(PHPATARR(FNBR12,IENS12,.02,"E"))
 . S @IADD@("bottle")=$G(PHPATARR(FNBR12,IENS12,.03,"E"))
 . S @IADD@("resourceId")=$$RESID^SYNDHP69("V",SITE,FNBR1,PHPATIEN,FNBR11_U_$P(IENS12,C,2)_U_FNBR12_U_+IENS12)
 ;
 N IENS13 S IENS13=""
 F  S IENS13=$O(PHPATARR(FNBR13,IENS13)) QUIT:IENS13=""  D
 . N ISOL S ISOL=$NA(PHPAT("Phpat","ivs","iv",$P(IENS13,C,2),"solutions","solution",+IENS13))
 . S @ISOL@("solution")=$G(PHPATARR(FNBR13,IENS13,.01,"E"))
 . S @ISOL@("solutionId")=$G(PHPATARR(FNBR13,IENS13,.01,"I"))
 . S @ISOL@("solutionGenericName")=$$GET1^DIQ(52.7,@ISOL@("solutionId")_",",1)
 . S @ISOL@("solutionGenericNameId")=$$GET1^DIQ(52.7,@ISOL@("solutionId")_",",1,"I")
 . S @ISOL@("solutionRxNorm")=$$GETRXN^SYNDHPUTL(@ISOL@("solutionGenericNameId"))
 . S @ISOL@("volume")=$G(PHPATARR(FNBR13,IENS13,1,"E"))
 . S @ISOL@("resourceId")=$$RESID^SYNDHP69("V",SITE,FNBR1,PHPATIEN,FNBR11_U_$P(IENS13,C,2)_U_FNBR13_U_+IENS13)
 ;
 QUIT
 ;