SYNDHP48 ; HC/PWC/art - HealthConcourse - retrieve patient medication data ;2019-11-01  11:51 AM
 ;;1.0;DHP;;Jan 17, 2017
 ;;
 ;;Original routine authored by Andrew Thompson & Ferdinand Frankson of Perspecta 2017-2019
 ;
 ; (c) 2017-2019 Perspecta
 ; (c) 2019 OSEHRA
 ; 
 ; Licensed under the Apache License, Version 2.0 (the "License");
 ; you may not use this file except in compliance with the License.
 ; You may obtain a copy of the License at
 ; 
 ; http://www.apache.org/licenses/LICENSE-2.0
 ; 
 ; Unless required by applicable law or agreed to in writing, software
 ; distributed under the License is distributed on an "AS IS" BASIS,
 ; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 ; See the License for the specific language governing permissions and
 ; limitations under the License.
 ;
 ;
 Q
 ;
 ; ---------------- Get patient medication statement ----------------------------
PATMEDS(RETSTA,DHPICN,FRDAT,TODAT) ; Patient medication statement for ICN
 ;
 ; Return patient medication statement for a given patient ICN
 ;
 ; Input:
 ;   ICN     - unique patient identifier across all VistA systems
 ;   FRDAT   - from date (inclusive), optional
 ;   TODAT   - to date (inclusive), optional
 ; Output:
 ;   RETSTA  - a delimited string that lists the following information
 ;      PatientICN ^ RESOURSE ID ^ STATUS ^ MEDICATION ^ DATE ASSERTED; DATE STARTED; DATE ENDED
 ;      ^ CONDITION ^ DOSAGE , SITE ; ROUTE ; DOSE ^ QUANTITY ^ DAYS ^ RXN |
 ;
 ;   Identifier will be "V"_SITE ID_"_"_FILEMAN #_"_"_FILE IEN   i.e. V_500_55_930
 ;
 ; validate ICN
STM ;
 ; ZEXCEPT: DEBUG
 I $G(DHPICN)="" S RETSTA="-1^What patient?" QUIT
 I '$$UICNVAL^SYNDHPUTL(DHPICN) S RETSTA="-1^Patient identifier not recognised" Q
 ;
 S FRDAT=$S($G(FRDAT):$$HL7TFM^XLFDT(FRDAT),1:1000101)
 S TODAT=$S($G(TODAT):$$HL7TFM^XLFDT(TODAT),1:9991231)
 I $G(DEBUG) W !,"FRDAT: ",FRDAT,"   TODAT: ",TODAT,!
 I FRDAT>TODAT S RETSTA="-1^From date is greater than to date" QUIT
 ;
 N C,ACU,P,S,UL,D1,IDENT,ORDDAT,ORDNUM,ROUTE,STATUS,DOSORD,STDT,STDTFM,DRUG,SITE,SITEA,VUID
 N RETDESC,QTY,DAYS,RXN,IENS,IDATE,IDATEFM,RX,PATIEN,DRUGI
 S C=",",P="|",S=";",UL="_"
 ; get patient IEN from ICN
 S PATIEN=$O(^DPT("AFICN",DHPICN,""))
 I PATIEN="" S RETSTA="-1^Internal data structure error" QUIT
 ;
 S RETDESC=""
 S SITE=$P($$SITE^VASITE,U,3)
 S RETSTA=""
 ; loop through the PHARMACY PATIENT file #55 (^PS(55)) for patient (this will contain both IP and OP orders)
 S (ORDDAT,ORDNUM,ROUTE,STATUS,DOSORD,STDT,STDTFM,DRUG,SITEA,QTY,DAYS,RXN)=""
 ;
 ; this is start of Inpatient Orders
 S D1=0
 F  S D1=$O(^PS(55,PATIEN,5,D1)) Q:D1'?1N.N  D
 .S IENS=D1_C_PATIEN_C
 .N MEDX,MEDERR
 .D GETS^DIQ(55.06,IENS,".01;3;10;28;27;34","IEN","MEDX","MEDERR")
 .QUIT:$D(MEDERR)
 .S ORDNUM=$G(MEDX(55.06,IENS,.01,"E"))   ; order number
 .; route is most likely not stored in vista as SCT code, but should check this
 .S ROUTE=$G(MEDX(55.06,IENS,3,"E"))      ; route
 .S STATUS=$G(MEDX(55.06,IENS,28,"E"))    ; status
 .S DOSORD=$P($G(^PS(55,PATIEN,5,D1,.2)),U,2)          ; dosage ordered
 .N SDTFM S SDTFM=$G(MEDX(55.06,IENS,10,"I"))      ; start date
 .QUIT:'$$RANGECK^SYNDHPUTL(SDTFM,FRDAT,TODAT)  ;quit if outside of requested date range
 .N ODTFM S ODTFM=$G(MEDX(55.06,IENS,27,"I"))       ; order date
 .N EDTFM S EDTFM=$G(MEDX(55.06,IENS,34,"I"))       ; stop date
 .N ODTHL7 S ODTHL7=$$FMTHL7^XLFDT(ODTFM)      ; order date
 .N SDTHL7 S SDTHL7=$$FMTHL7^XLFDT(SDTFM)      ; start date
 .N EDTHL7 S EDTHL7=$$FMTHL7^XLFDT(EDTFM)      ; end date
 .S DRUG=$$GET1^DIQ(55.07,1_C_IENS,.01,"E")  ; medication
 .S DRUGI=$$GET1^DIQ(55.07,1_C_IENS,.01,"I")
 .S RXN=$$GETRXN^SYNDHPUTL(DRUGI)
 .I RXN S RXN="RXN"_RXN
 .E  S VUID=$$GETVUID(DRUGI) I VUID S RXN="VUID"_VUID
 .E  S RXN="DRUG"_DRUGI
 .S IDENT=$$RESID^SYNDHP69("V",SITE,55,PATIEN,55.06_U_D1)
 .S RETDESC=RETDESC_IDENT_U_STATUS_U_DRUG_U_ODTHL7_S_SDTHL7_S_EDTHL7_U_"REASON"_U_SITEA_S_ROUTE_S_DOSORD_U_QTY_U_DAYS_U_RXN_P
 ;
 ; start here for outpatient orders
 S D1=0
 F  S D1=$O(^PS(55,PATIEN,"P",D1)) Q:D1'?1N.N  D
 . S RX=$G(^PS(55,PATIEN,"P",D1,0))
 . S (IDENT,IDATE,DRUG,QTY,DAYS,STATUS,ROUTE,RXN)=""
 . N MEDX,MEDERR
 . D GETS^DIQ(52,RX_",",".01;1;2;6;7;8;100;26;22","IEN","MEDX","MEDERR")
 . QUIT:$D(MEDERR)
 . S IDENT=$$RESID^SYNDHP69("V",SITE,52,RX)
 . S IDATEFM=$G(MEDX(52,RX_",",1,"I"))               ;issue date
 . QUIT:'$$RANGECK^SYNDHPUTL(IDATEFM,FRDAT,TODAT)    ;quit if outside of requested date range
 . N FDATEFM S FDATEFM=$G(MEDX(52,RX_",",22,"I"))    ;fill date
 . N EDATEFM S EDATEFM=$G(MEDX(52,RX_",",26,"I"))    ;expiration date
 . S IDATE=$$FMTHL7^XLFDT(IDATEFM)                   ;issue date HL7
 . N SDATE S SDATE=$$FMTHL7^XLFDT(FDATEFM)           ;start date HL7
 . N EDATE S EDATE=$$FMTHL7^XLFDT(EDATEFM)           ;end date hl7
 . S DRUG=$G(MEDX(52,RX_",",6,"E"))                  ;medication
 . S DRUGI=$G(MEDX(52,RX_",",6,"I"))
 . S RXN=$$GETRXN^SYNDHPUTL(DRUGI)
 . I RXN S RXN="RXN"_RXN
 . E  S VUID=$$GETVUID(DRUGI) I VUID S RXN="VUID"_VUID
 . E  S RXN="DRUG"_DRUGI
 . S QTY=$G(MEDX(52,RX_",",7,"E"))       ;quantity
 . S DAYS=$G(MEDX(52,RX_",",8,"E"))      ;days supply
 . S STATUS=$G(MEDX(52,RX_",",100,"E"))  ;status
 . S ROUTE=$$GET1^DIQ(52.0113,"1,"_RX_",",6,"EN")  ;route
 . S RETDESC=RETDESC_IDENT_U_STATUS_U_DRUG_U_IDATE_S_SDATE_S_EDATE_U_"REASON"_U_SITEA_S_ROUTE_S_DOSORD_U_QTY_U_DAYS_U_RXN_P
 S RETSTA=DHPICN_U_RETDESC
 Q
 ;
 ; ---------------- Get patient medication administration ----------------------------
PATMEDA(RETSTA,DHPICN,FRDAT,TODAT) ; Patient medication administration for ICN
 ;
 ; Return patient medication administration for a given patient ICN
 ;
 ; Input:
 ;   ICN     - unique patient identifier across all VistA systems
 ;   FRDAT   - from date (inclusive), optional
 ;   TODAT   - to date (inclusive), optional
 ; Output:
 ;   RETSTA  - a delimited string that lists the following information
 ;      PatientICN ^ RESOURSE ID ^ STATUS ^ MEDICATION ^ DATE ASSERTED ^ CONDITION
 ;      ^ DOSAGE , SITE ; ROUTE ; DOSE ^ QUANTITY ^ DAYS ^ RXN |
 ;
 ;   Identifier will be "V"_SITE ID_"_"_FILEMAN #_"_"_FILE IEN   i.e. V_500_55_930
 ;
 ; validate ICN
STA ;
 I $G(DHPICN)="" S RETSTA="-1^What patient?" QUIT
 I '$$UICNVAL^SYNDHPUTL(DHPICN) S RETSTA="-1^Patient identifier not recognised" Q
 ;
 S FRDAT=$S($G(FRDAT):$$HL7TFM^XLFDT(FRDAT),1:1000101)
 S TODAT=$S($G(TODAT):$$HL7TFM^XLFDT(TODAT),1:9991231)
 I $G(DEBUG) W !,"FRDAT: ",FRDAT,"   TODAT: ",TODAT,!
 I FRDAT>TODAT S RETSTA="-1^From date is greater than to date" QUIT
 ;
 N C,ACU,P,S,UL,D1,IDENT,ORDDAT,ORDNUM,ROUTE,STATUS,DOSORD,STDT,STDTFM,DRUG,SITE ;,IENS
 N RETDESC,SITEA,QTY,DAYS,RXN,IDATE,IDATEFM,PATIEN,DRUGI,RX
 S C=",",P="|",S=";",UL="_"
 ; get patient IEN from ICN
 S PATIEN=$O(^DPT("AFICN",DHPICN,""))
 I PATIEN="" S RETSTA="-1^Internal data structure error" QUIT
 ;
 S RETDESC=""
 S SITE=$P($$SITE^VASITE,U,3)
 S RETSTA=""
 ; loop through the PHARMACY PATIENT file #55 (^PS(55)) for patient (this will contain both IP and OP orders)
 ;
 ; this is start of Inpatient Orders
 S D1=0
 F  S D1=$O(^PS(55,PATIEN,5,D1)) Q:D1'?1N.N  D
 .S IENS=D1_C_PATIEN_C
 .S (ORDDAT,ORDNUM,ROUTE,STATUS,DOSORD,STDT,STDTFM,DRUG,SITEA,QTY,DAYS,RXN)=""
 .N MEDX,MEDERR
 .D GETS^DIQ(55.06,IENS,".01;3;10;28","IEN","MEDX","MEDERR")
 .QUIT:$D(MEDERR)
 .S ORDNUM=$G(MEDX(55.06,IENS,.01,"E"))   ; order number
 .; route is most likely not stored in vista as SCT code, but should check this
 .S ROUTE=$G(MEDX(55.06,IENS,3,"E"))      ; route
 .S STATUS=$G(MEDX(55.06,IENS,28,"E"))    ; status
 .S DOSORD=$P($G(^PS(55,PATIEN,5,D1,.2)),U,2)          ; dosage ordered
 .S STDTFM=$G(MEDX(55.06,IENS,10,"I"))      ; start date
 .QUIT:((STDTFM\1)<FRDAT)!((STDTFM\1)>TODAT)  ;quit if outside of requested date range
 .S STDT=$$FMTHL7^XLFDT($G(MEDX(55.06,IENS,10,"I")))      ; start date
 .S DRUG=$$GET1^DIQ(55.07,1_C_IENS,.01,"E")  ; medication
 .S DRUGI=$$GET1^DIQ(55.07,1_C_IENS,.01,"I")
 .S RXN=$$GETRXN^SYNDHPUTL(DRUGI)
 .I RXN?1.N S RXN="RXN"_RXN
 .S IDENT=$$RESID^SYNDHP69("V",SITE,55,PATIEN,55.06_U_D1)
 .S RETDESC=RETDESC_$G(IDENT)_U_$G(STATUS)_U_$G(DRUG)_U_$G(STDT)_U_"REASON"_U_$G(SITEA)_S_$G(ROUTE)_S_$G(DOSORD)_U_$G(QTY)_U_$G(DAYS)_U_$G(RXN)_P
 ;
 ; start here for outpatient orders
 S D1=0
 F  S D1=$O(^PS(55,PATIEN,"P",D1)) Q:D1'?1N.N  D
 . S RX=$G(^PS(55,PATIEN,"P",D1,0))
 . S (IDENT,IDATE,DRUG,QTY,DAYS,STATUS,ROUTE)=""
 . N MEDX,MEDERR
 . D GETS^DIQ(52,RX_",",".01;1;2;6;7;8;100","IEN","MEDX","MEDERR")
 . QUIT:$D(MEDERR)
 . S IDENT=$$RESID^SYNDHP69("V",SITE,52,RX)
 . S IDATEFM=$G(MEDX(52,RX_",",1,"I"))     ;issue date
 . QUIT:((IDATEFM\1)<FRDAT)!((IDATEFM\1)>TODAT)  ;quit if outside of requested date range
 . S IDATE=$$FMTHL7^XLFDT($G(MEDX(52,RX_",",1,"I")))     ;issue date
 . S DRUG=$G(MEDX(52,RX_",",6,"E"))      ;medication
 . S DRUGI=$G(MEDX(52,RX_",",6,"I"))
 . S RXN=$$GETRXN^SYNDHPUTL(DRUGI)
 . I RXN?1.N S RXN="RXN"_RXN
 . S QTY=$G(MEDX(52,RX_",",7,"E"))       ;quantity
 . S DAYS=$G(MEDX(52,RX_",",8,"E"))      ;days supply
 . S STATUS=$G(MEDX(52,RX_",",100,"E"))  ;status
 . S ROUTE=$$GET1^DIQ(52.0113,"1,"_RX_",",6,"EN")  ;route
 . S RETDESC=RETDESC_$G(IDENT)_U_$G(STATUS)_U_$G(DRUG)_U_$G(IDATE)_U_"REASON"_U_$G(SITEA)_S_$G(ROUTE)_S_$G(DOSORD)_U_$G(QTY)_U_$G(DAYS)_U_$G(RXN)_P
 S RETSTA=DHPICN_U_RETDESC
 Q
 ;
 ; ---------------- Get patient medication dispense ----------------------------
 ;
PATMEDD(RETSTA,DHPICN,FRDAT,TODAT) ; Patient medication dispense for ICN
 ;
 ; Return patient medication dispense for a given patient ICN
 ;
 ; Input:
 ;   ICN     - unique patient identifier across all VistA systems
 ;   FRDAT   - from date (inclusive), optional
 ;   TODAT   - to date (inclusive), optional
 ; Output:
 ;   RETSTA  - a delimited string that lists the following information
 ;      PatientICN ^ RESOURSE ID ^ STATUS ^ MEDICATION ^ DATE ASSERTED ^ CONDITION
 ;      ^ DOSAGE , SITE ; ROUTE ; DOSE ^ QUANTITY ^ DAYS ^ RXN |
 ;
 ;   Identifier will be "V"_SITE ID_"_"_FILEMAN #_"_"_FILE IEN   i.e. V_500_55_930
 ;
 ; validate ICN
 I $G(DHPICN)="" S RETSTA="-1^What patient?" QUIT
 I '$$UICNVAL^SYNDHPUTL(DHPICN) S RETSTA="-1^Patient identifier not recognised" Q
 ;
 S FRDAT=$S($G(FRDAT):$$HL7TFM^XLFDT(FRDAT),1:1000101)
 S TODAT=$S($G(TODAT):$$HL7TFM^XLFDT(TODAT),1:9991231)
 I $G(DEBUG) W !,"FRDAT: ",FRDAT,"   TODAT: ",TODAT,!
 I FRDAT>TODAT S RETSTA="-1^From date is greater than to date" QUIT
 ;
 N C,ACU,P,S,UL,D1,IDENT,ORDDAT,ORDNUM,ROUTE,STATUS,DOSORD,STDT,STDTFM,DRUG,SITEA
 N RETDESC,SITE,QTY,DAYS,RXN,PATIEN,RX
 S C=",",P="|",S=";",UL="_"
 ; get patient IEN from ICN
 S PATIEN=$O(^DPT("AFICN",DHPICN,""))
 I PATIEN="" S RETSTA="-1^Internal data structure error" QUIT
 ;
 S RETDESC=""
 S SITE=$P($$SITE^VASITE,U,3)
 S RETSTA=""
 ; loop through the PHARMACY PATIENT file #55 (^PS(55)) for patient (this will contain both IP and OP orders).
 ; OP orders will need to get additional information from the PRESCRIPTION file #52 (^PSRX)
 S D1=0
 F  S D1=$O(^PS(55,PATIEN,5,D1)) Q:D1'?1N.N  D
 .S IENS=D1_C_PATIEN_C
 .S (ORDDAT,ORDNUM,ROUTE,STATUS,DOSORD,STDT,STDTFM,DRUG,SITEA,QTY,DAYS,RXN)=""
 .N MEDX,MEDERR
 .D GETS^DIQ(55.06,IENS,".01;3;10;28","IEN","MEDX","MEDERR")
 .QUIT:$D(MEDERR)
 .S ORDNUM=$G(MEDX(55.06,IENS,.01,"E"))   ; order number
 .; route is most likely not stored in vista as SCT code, but should check this
 .S ROUTE=$G(MEDX(55.06,IENS,3,"E"))      ; route
 .S STATUS=$G(MEDX(55.06,IENS,28,"E"))    ; status
 .S DOSORD=$P($G(^PS(55,PATIEN,5,D1,.2)),U,2)          ; dosage ordered
 .S STDTFM=$G(MEDX(55.06,IENS,10,"I"))      ; start date
 .QUIT:'$$RANGECK^SYNDHPUTL(STDTFM,FRDAT,TODAT)  ;quit if outside of requested date range
 .S STDT=$$FMTHL7^XLFDT($G(MEDX(55.06,IENS,10,"I")))      ; start date
 .S DRUG=$$GET1^DIQ(55.07,1_C_IENS,.01,"E")  ; medication
 .S DRUGI=$$GET1^DIQ(55.07,1_C_IENS,.01,"I")
 .S RXN=$$GETRXN^SYNDHPUTL(DRUGI)
 .I RXN?1.N S RXN="RXN"_RXN
 .S IDENT=$$RESID^SYNDHP69("V",SITE,55,PATIEN,55.06_U_D1)
 .S RETDESC=RETDESC_$G(IDENT)_U_$G(STATUS)_U_$G(DRUG)_U_$G(STDT)_U_"REASON"_U_$G(SITEA)_S_$G(ROUTE)_S_$G(DOSORD)_U_$G(QTY)_U_$G(DAYS)_U_$G(RXN)_P
 ;
 S RETSTA=DHPICN_U_RETDESC
 Q
 ;
GETVUID(X) ; [Public] Get VUID for drug
 Q $$GET1^DIQ(50,X,"22:99.99")
 ;
TEST D EN^%ut($T(+0),3) QUIT
STARTUP ; [Constants] Modify to suit your system so tests would pass.
 ; ZEXCEPT:ICN1,ICN2
 S ICNOP="2421492932V802082"
 S ICNIN="9990000005V380966"
 QUIT
SHUTDOWN ;
 ; ZEXCEPT:ICN1,ICN2
 K ICN1,ICN2
 QUIT
 ;
T1 ;
 N ICN S ICN=""
 F  S ICN=$O(^DPT("AFICN",ICN)) Q:ICN=""  D
 .W !!!,ICN,!!!
 .D PATMEDA(.RETSTA,ICN)
 .W $$ZW^SYNDHPUTL("RETSTA")
 .W !!!
 Q
 ;
T2 ;
 N ICN S ICN=""
 F  S ICN=$O(^DPT("AFICN",ICN)) Q:ICN=""  D
 .W !,ICN,!
 .D PATMEDD(.RETSTA,ICN)
 .W $$ZW^SYNDHPUTL("RETSTA"),!!
 Q
 ;
T3 ;
 N ICN,XPIEN
 S ICN=""
 F  S ICN=$O(^DPT("AFICN",ICN)) Q:ICN=""  D
 .S XPIEN=$O(^DPT("AFICN",ICN,""))
 .W !,ICN,!,XPIEN,!,^DPT(XPIEN,0),!
 .D PATMEDS(.RETSTA,ICN)
 .W $$ZW^SYNDHPUTL("RETSTA"),!!
 Q
 ;
T4 ;
 N ICN S ICN="5000000341V359724"
 N FRDAT S FRDAT=""
 N TODAT S TODAT=""
 N RETSTA
 D PATMEDA(.RETSTA,ICN,FRDAT,TODAT)
 W $$ZW^SYNDHPUTL("RETSTA"),!!
 QUIT
 ;
T5 ;
 N ICN S ICN="5000000341V359724"
 N FRDAT S FRDAT=20100101
 N TODAT S TODAT=20150101
 N RETSTA
 D PATMEDA(.RETSTA,ICN,FRDAT,TODAT)
 W $$ZW^SYNDHPUTL("RETSTA"),!!
 QUIT
 ;
T6 ;
 N ICN S ICN="5000000341V359724"
 N FRDAT S FRDAT=""
 N TODAT S TODAT=""
 N RETSTA
 D PATMEDD(.RETSTA,ICN,FRDAT,TODAT)
 W $$ZW^SYNDHPUTL("RETSTA"),!!
 QUIT
 ;
T7 ;
 N ICN S ICN="5000000341V359724"
 N FRDAT S FRDAT=20100101
 N TODAT S TODAT=20150101
 N RETSTA
 D PATMEDD(.RETSTA,ICN,FRDAT,TODAT)
 W $$ZW^SYNDHPUTL("RETSTA"),!!
 QUIT
 ;
T8 ;
 N ICN S ICN="5000000341V359724"
 N FRDAT S FRDAT=""
 N TODAT S TODAT=""
 N RETSTA
 D PATMEDS(.RETSTA,ICN,FRDAT,TODAT)
 W $$ZW^SYNDHPUTL("RETSTA"),!!
 QUIT
 ;
T9 ;
 N ICN S ICN="5000000341V359724"
 N FRDAT S FRDAT=20100101
 N TODAT S TODAT=20150101
 N RETSTA
 D PATMEDS(.RETSTA,ICN,FRDAT,TODAT)
 W $$ZW^SYNDHPUTL("RETSTA"),!!
 QUIT
 ;
T10 ; @TEST Test Outpatient Medications
 N RETSTA
 D PATMEDS(.RETSTA,ICNOP)
 N I F I=1:1:$L(RETSTA,"|") W $P(RETSTA,"|",I),!
 D CHKTF^%ut($L(RETSTA,"|"))
 QUIT
T11 ; @TEST Test Inpatient Medications
 N RETSTA
 D PATMEDS(.RETSTA,ICNIN)
 N I F I=1:1:$L(RETSTA,"|") W $P(RETSTA,"|",I),!
 D CHKTF^%ut($L(RETSTA,"|"))
 QUIT
 ;
 ;Statement
 ;IP S RETDESC=RETDESC_$G(IDENT)_U_$G(STATUS)_U_$G(DRUG)_U_$G(STDT)_U_"REASON"_U_$G(SITEA)_S_$G(ROUTE)_S_$G(DOSORD)_U_QTY_U_DAYS_U_RXN_P
 ;OP S RETDESC=RETDESC_$G(IDENT)_U_$G(STATUS)_U_$G(DRUG)_U_$G(IDATE)_U_"REASON"_U_$G(SITEA)_S_$G(ROUTE)_S_$G(DOSORD)_U_QTY_U_DAYS_U_RXN_P
 ;Administer
 ;IP S RETDESC=RETDESC_$G(IDENT)_U_$G(STATUS)_U_$G(DRUG)_U_$G(STDT)_U_"REASON"_U_$G(SITEA)_S_$G(ROUTE)_S_$G(DOSORD)_U_QTY_U_DAYS_U_RXN_P
 ;OP S RETDESC=RETDESC_$G(IDENT)_U_$G(STATUS)_U_$G(DRUG)_U_$G(IDATE)_U_"REASON"_U_$G(SITEA)_S_$G(ROUTE)_S_$G(DOSORD)_U_QTY_U_DAYS_U_RXN_P
 ;Dispense
 ;IP S RETDESC=RETDESC_$G(IDENT)_U_$G(STATUS)_U_$G(DRUG)_U_$G(STDT)_U_"REASON"_U_$G(SITEA)_S_$G(ROUTE)_S_$G(DOSORD)_U_QTY_U_DAYS_U_$G(RXN)_P
