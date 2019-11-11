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

package com.skytech.eapp;

import android.os.Bundle;
import android.view.KeyEvent;
import android.widget.Toast;


import org.apache.cordova.*;

public class NewActivity extends CordovaActivity
{
    private final String BOTTOMTOTOP = "by_bottom";
    private final String RIGHTTOLEFT = "by_right";


    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        ChangePush();
        super.onCreate(savedInstanceState);
        try {
            launchUrl=getIntent().getExtras().getString("url");
        }catch (Exception e){
            launchUrl="";
            Toast.makeText(NewActivity.this,"要填写地址啊",Toast.LENGTH_SHORT).show();
        }
        // enable Cordova apps to be started in the background
        Bundle extras = getIntent().getExtras();
        if (extras != null && extras.getBoolean("cdvStartInBackground", false)) {
            moveTaskToBack(true);
        }
        // Set by <content src="index.html" /> in config.xml
        loadUrl(launchUrl);
    }

    private void ChangePush() {
        int ZOOMENTERTOP=getResources().getIdentifier("zoom_enter_top","anim",getPackageName());
        int ZOOMOUTTOP=getResources().getIdentifier("zoom_out_top","anim",getPackageName());
        int ZOOMENTERLEFT=getResources().getIdentifier("zoom_enter_left","anim",getPackageName());
        int ZOOMOULEFT=getResources().getIdentifier("zoom_out_left","anim",getPackageName());
        if(BOTTOMTOTOP.equals(EappPlugin.OPENTYPE)){
            overridePendingTransition(ZOOMENTERTOP, ZOOMOUTTOP);
        }else {
            overridePendingTransition(ZOOMENTERLEFT,ZOOMOULEFT);
        }
    }

    public void onBack(){
        finish();
        ChangePush();
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            return true;
        }
        return false;
    }

}
