/* Created by Perspecta http://www.perspecta.com */
/*
        Licensed to the Apache Software Foundation (ASF) under one
        or more contributor license agreements.  See the NOTICE file
        distributed with this work for additional information
        regarding copyright ownership.  The ASF licenses this file
        to you under the Apache License, Version 2.0 (the
        "License"); you may not use this file except in compliance
        with the License.  You may obtain a copy of the License at
        http://www.apache.org/licenses/LICENSE-2.0
        Unless required by applicable law or agreed to in writing,
        software distributed under the License is distributed on an
        "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
        KIND, either express or implied.  See the License for the
        specific language governing permissions and limitations
        under the License.
*/
package com.healthconcourse.vista.fhir.api.test.parser;

import com.healthconcourse.vista.fhir.api.parser.EncounterParser;
import org.hl7.fhir.dstu3.model.Encounter;
import org.junit.Assert;
import org.junit.Test;

import java.util.List;

public class EncounterParserTest {


    @Test
    public void TestSuccessfulEncounterParse(){
        String input = "5000001533V676621^507_9000010_11525^VA^NOV 19, 2013@08:00^^;^AMBULATORY^^CAMP MASTER,VA MEDICAL CENTER;1 3RD sT.;ALBANY;12180-0097^GENERAL MEDICINE|507_9000010_11526^VA^NOV 19, 2013@08:00^^;^ANCILLARY PACKAGE DAILY DATA^^CAMP MASTER,VA MEDICAL CENTER;1 3RD sT.;ALBANY;12180-0097^GENERAL MEDICINE|507_9000010_11527^VA^NOV 19, 2013@09:27^^;^ANCILLARY PACKAGE DAILY DATA^LAB DATA^CAMP MASTER,VA MEDICAL CENTER;1 3RD sT.;ALBANY;12180-0097^LAB DIV 500 OOS ID 108|507_9000010_11531^VA^SEP 22, 2014@13:00^^;^AMBULATORY^^CAMP MASTER,VA MEDICAL CENTER;1 3RD sT.;ALBANY;12180-0097^PRIMARY CARE|507_9000010_11532^VA^DEC 01, 2014@13:00^^;^AMBULATORY^^CAMP MASTER,VA MEDICAL CENTER;1 3RD sT.;ALBANY;12180-0097^PRIMARY CARE|507_9000010_11533^VA^MAR 01, 2015@13:00^^;^AMBULATORY^^CAMP MASTER,VA MEDICAL CENTER;1 3RD sT.;ALBANY;12180-0097^PRIMARY CARE|507_9000010_11535^VA^NOV 26, 2013@16:52^^;^TELECOMMUNICATIONS^TEXT INTEGRATION UTILITIES^CAMP MASTER,VA MEDICAL CENTER;1 3RD sT.;ALBANY;12180-0097^PRIMARY CARE TELEPHONE|507_9000010_11537^VA^NOV 19, 2013@09:24^^;^ANCILLARY PACKAGE DAILY DATA^LAB DATA^CAMP MASTER,VA MEDICAL CENTER;1 3RD sT.;ALBANY;12180-0097^LAB DIV 500 OOS ID 108|507_9000010_11538^VA^SEP 29, 2014@12:57^^;^ANCILLARY PACKAGE DAILY DATA^LAB DATA^CAMP MASTER,VA MEDICAL CENTER;1 3RD sT.;ALBANY;12180-0097^LAB DIV 500 OOS ID 108|507_9000010_11539^VA^MAR 13, 2015@13:44^^;^ANCILLARY PACKAGE DAILY DATA^LAB DATA^CAMP MASTER,VA MEDICAL CENTER;1 3RD sT.;ALBANY;12180-0097^LAB DIV 500 OOS ID 108|507_9000010_11548^VA^SEP 29, 2014@17:13^^;^TELECOMMUNICATIONS^TEXT INTEGRATION UTILITIES^CAMP MASTER,VA MEDICAL CENTER;1 3RD sT.;ALBANY;12180-0097^PRIMARY CARE TELEPHONE|507_9000010_11549^VA^MAR 13, 2015@15:28^^;^TELECOMMUNICATIONS^TEXT INTEGRATION UTILITIES^CAMP MASTER,VA MEDICAL CENTER;1 3RD sT.;ALBANY;12180-0097^PRIMARY CARE TELEPHONE|507_9000010_11608^VA^JUL 20, 2015@13:00^^;^AMBULATORY^^CAMP MASTER,VA MEDICAL CENTER;1 3RD sT.;ALBANY;12180-0097^PRIMARY CARE|507_9000010_11615^VA^JUL 13, 2015@08:21^^;^TELECOMMUNICATIONS^TEXT INTEGRATION UTILITIES^CAMP MASTER,VA MEDICAL CENTER;1 3RD sT.;ALBANY;12180-0097^PRIMARY CARE TELEPHONE|507_9000010_11616^VA^JUL 20, 2015@08:39^^;^ANCILLARY PACKAGE DAILY DATA^LAB DATA^CAMP MASTER,VA MEDICAL CENTER;1 3RD sT.;ALBANY;12180-0097^LAB DIV 500 OOS ID 108|507_9000010_11617^VA^JUL 29, 2015@09:46^^;^TELECOMMUNICATIONS^TEXT INTEGRATION UTILITIES^CAMP MASTER,VA MEDICAL CENTER;1 3RD sT.;ALBANY;12180-0097^PRIMARY CARE TELEPHONE|507_9000010_11777^VA^DEC 04, 2015@12:30^^;^AMBULATORY^^CAMP MASTER,VA MEDICAL CENTER;1 3RD sT.;ALBANY;12180-0097^PRIMARY CARE|\n";

        EncounterParser parser = new EncounterParser();

        List<Encounter> result = parser.parseList(input);

        Assert.assertEquals("Correct number of records", 17, result.size());
    }

    @Test
    public void TestNoEncounterParse(){
        String input = "5000000325V783252^";

        EncounterParser parser = new EncounterParser();

        List<Encounter> result = parser.parseList(input);

        Assert.assertEquals("Correct number of records", 0, result.size());
    }

    @Test
    public void TestNoDataEncounterParse(){
        String input = "";

        EncounterParser parser = new EncounterParser();

        List<Encounter> result = parser.parseList(input);

        Assert.assertEquals("Correct number of records", 0, result.size());
    }
}
