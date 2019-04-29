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

import com.healthconcourse.vista.fhir.api.parser.AppointmentParser;
import org.hl7.fhir.dstu3.model.Appointment;
import org.junit.Assert;
import org.junit.Test;

import java.util.List;

public class AppointmentParserTest {

    @Test
    public void TestSuccesfulAppointmentParse() {
        String input = "5000001640V413398^1_198811010900-0500|ORTHO-CLINIC|CANCELLED BY PATIENT|SCHEDULED VISIT|REGULAR^1_198907030800-0500|TDENTAL|CANCELLED BY CLINIC|SCHEDULED VISIT|REGULAR^1_198908110800-0500|NEUROSURGEON|INPATIENT APPOINTMENT|SCHEDULED VISIT|REGULAR^1_199109300900-0500|PRIMARY CARE||SCHEDULED VISIT|REGULAR^1_199110010800-0500|PRIMARY CARE||SCHEDULED VISIT|REGULAR^1_199110020800-0500|GENERAL MEDICINE||SCHEDULED VISIT|REGULAR^1_199110021330-0500|AUDIOLOGY||SCHEDULED VISIT|REGULAR^1_199204010800-0500|GENERAL MEDICINE||SCHEDULED VISIT|REGULAR^1_199204010801-0500|GENERAL MEDICINE||UNSCHED. VISIT|REGULAR^1_199212161300-0500|FILE ROOM REQUEST|NO ACTION TAKEN|SCHEDULED VISIT|REGULAR^1_199212220900-0500|RYMANOWSKI|NO ACTION TAKEN|SCHEDULED VISIT|REGULAR^1_199310141400-0500|GENERAL MEDICINE||SCHEDULED VISIT|REGULAR^1_199310150800-0500|GENERAL MEDICINE||SCHEDULED VISIT|REGULAR^1_199401110900-0500|BON-HBHC SOCIAL WORK|CANCELLED BY PATIENT|SCHEDULED VISIT|REGULAR^1_199402281100-0500|PAT GM/SURG|NO ACTION TAKEN|SCHEDULED VISIT|REGULAR^1_199404151130-0500|NUCLEAR MEDICINE||SCHEDULED VISIT|REGULAR^1_199408290800-0500|X-RAY||SCHEDULED VISIT|REGULAR^1_199410210800-0500|SHERYL'S CLINIC|CANCELLED BY PATIENT|SCHEDULED VISIT|REGULAR^1_199410211000-0500|SHERYL'S CLINIC|NO ACTION TAKEN|SCHEDULED VISIT|REGULAR^1_199410280900-0500|ORTHO-CLINIC|NO ACTION TAKEN|SCHEDULED VISIT|REGULAR^1_199411170800-0500|SHERYL'S CLINIC||SCHEDULED VISIT|REGULAR^1_199411180900-0500|SHERYL'S CLINIC||SCHEDULED VISIT|REGULAR^1_199411220800-0500|SHERYL'S CLINIC|CANCELLED BY PATIENT|SCHEDULED VISIT|REGULAR^1_199509290800-0500|LINDA'S FUNNY CLINIC|CANCELLED BY PATIENT|SCHEDULED VISIT|REGULAR^1_199511050800-0500|GENERAL MEDICINE||SCHEDULED VISIT|REGULAR^1_199608231000-0500|PRIMARY CARE|NO ACTION TAKEN|SCHEDULED VISIT|REGULAR^1_199608301300-0500|20 MINUTE|CANCELLED BY CLINIC|SCHEDULED VISIT|REGULAR^1_199701270800-0500|SURGICAL CLINIC||SCHEDULED VISIT|REGULAR^1_199901251445-0500|MIKE'S MEDICAL CLINIC||UNSCHED. VISIT|REGULAR^1_199901251526-0500|MIKES MENTAL CLINIC||UNSCHED. VISIT|REGULAR";

        AppointmentParser parser = new AppointmentParser();

        List<Appointment> result = parser.parseList(input);

        Assert.assertEquals("Correct number of items", 30, result.size());
    }

    @Test
    public void TestNoAppointmentParse() {
        String input = "5000000325V783252";

        AppointmentParser parser = new AppointmentParser();

        List<Appointment> result = parser.parseList(input);

        Assert.assertEquals("Correct number of items", 0, result.size());
    }

    @Test
    public void TestNoAppointmentDataParse() {
        String input = "";

        AppointmentParser parser = new AppointmentParser();

        List<Appointment> result = parser.parseList(input);

        Assert.assertEquals("Correct number of items", 0, result.size());
    }
}
