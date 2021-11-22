package com.studios.stealth.dare2drinkFree;

;
import android.Manifest;
import android.content.DialogInterface;
import android.content.Intent;

import android.content.pm.PackageManager;
import android.database.Cursor;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.text.Html;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.Spinner;

import android.widget.Toast;

import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.AdView;
import com.google.android.gms.ads.MobileAds;

import java.io.BufferedReader;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

import java.util.ArrayList;


public class MainActivity extends AppCompatActivity{

    private static final int REQUESTING=0;

    ArrayList<Order> dares = new ArrayList<Order>();
    ArrayList<Order> wildCards = new ArrayList<Order>();
    static DataBaseHelper dbhelper;
    static int proba;
    private boolean isStarting=false;
    private LinearLayout adContainer;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);



        File probabi = new File(MainActivity.this.getFilesDir(),"proba.txt");
        if(!probabi.exists()){
            proba=40;
            try{
                FileWriter fw = new FileWriter(probabi);
                fw.write("40");
                fw.flush();
                fw.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        else{
            try{
                BufferedReader fr = new BufferedReader(new FileReader(new File(MainActivity.this.getFilesDir(),"proba.txt")));
                proba=Integer.parseInt(fr.readLine());
                fr.close();
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }


        dbhelper = new DataBaseHelper(this);
        try{
            dbhelper.createDataBase();
            dbhelper.openDataBase();
        }catch(Exception e){
            e.printStackTrace();
        }

        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);
        setContentView(R.layout.activity_main);
        adContainer =  findViewById(R.id.adView_Main_Container);
        RelativeLayout rl = (RelativeLayout) findViewById(R.id.activity_main);
        rl.setBackgroundResource(R.drawable.background);
        rl.setSystemUiVisibility(View.SYSTEM_UI_FLAG_FULLSCREEN);

        final Button start = (Button) findViewById(R.id.startttt);
        System.out.println(start);

        final Spinner spinner = (Spinner) findViewById(R.id.spinner);
        spinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {

            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                if(spinner.getSelectedItemPosition()>0){
                    if(isStarting)
                        start.performClick();
                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });


        start.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(ContextCompat.checkSelfPermission(MainActivity.this, Manifest.permission.READ_EXTERNAL_STORAGE)== PackageManager.PERMISSION_GRANTED
                        &&ContextCompat.checkSelfPermission(MainActivity.this, Manifest.permission.WRITE_EXTERNAL_STORAGE)== PackageManager.PERMISSION_GRANTED){
                    Log.d("READ/WRITE","PERMISSION ALREADY GRANTED");
                    if(spinner.getSelectedItemPosition()==0)
                    {
                        Toast.makeText(MainActivity.this, "Pick a Level", Toast.LENGTH_SHORT).show();
                        spinner.performClick();
                        isStarting=true;
                        return;
                    }
                    else if(spinner.getSelectedItemPosition()==1){
                        Toast.makeText(MainActivity.this, "Beginner Level coming soon", Toast.LENGTH_SHORT).show();
                        isStarting=false;
                        return;
                    }
                    else{
                        isStarting=false;
                        loadTheGuns(spinner.getSelectedItemPosition());
                    }
                    ArrayList<ArrayList<Order>> extras=new ArrayList<ArrayList<Order>>();
                    extras.add(dares);
                    extras.add(wildCards);
                    Intent it = new Intent(MainActivity.this,insideGame.class);
                    it.putExtra("extras",extras);
                    startActivity(it);
                }
                else{
                    isStarting=true;
                    ActivityCompat.requestPermissions(MainActivity.this,new String[]{Manifest.permission.READ_EXTERNAL_STORAGE,Manifest.permission.WRITE_EXTERNAL_STORAGE},REQUESTING);
                }

            }
        });

        Button stateTheRules = (Button) findViewById(R.id.rules);
        stateTheRules.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                AlertDialog.Builder builder = new AlertDialog.Builder(MainActivity.this);
                builder.setTitle("THE RULES");
                builder.setMessage(Html.fromHtml("<html><b>Description:</b><br><br>" +
                        "This is a simple Drink or Dare game, you receive a dare, you can choose to do the dare " +
                        "or drink the equivalent amount of shots for that dare.<br>" +
                        "Swipe right if you choose to do the dare and swipe left otherwise.<br>" +
                        "At a random swipe, a popup will show asking you to do what it says.<br><br>" +
                        "<b>The Rules are as follow:</b><br><br>" +
                        "- The developper is not responsible for any loss of virginities, drunk drivers, angry girlfriends," +
                        " nuclear war, or breakups.<br>" +
                        "- Any dare can be done in a private room ;)<br>" +
                        "- Any ties in any condition can be settled with a coin flip.<br>" +
                        "&nbsp;&nbsp;(I.E. closest player with opposite sex are the same on your sides)<br>" +
                        "- Any given time in a dare can be extended to as long as the dare receivers want. However" +
                        ",&nbsp;a given time cannot be shrunk.<br>" +
                        "- If you fail to end the dare at a time less than the one given YOU MUST RESTART.<br>" +
                        "- If there are any couples in this game, you both agree to do the dares that you get otherwise, fuck you," +
                        "&nbsp;you don't have to play<br>" +
                        "- Ofc, play responsibly and drink responsibly... and all the shit your parents would tell ya *rolls eyes*</html>"))
                        .setCancelable(true)
                        .setNeutralButton("Ok", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialogInterface, int i) {
                                dialogInterface.dismiss();;
                            }
                        });


                AlertDialog alertDialog = builder.create();
                alertDialog.show();
            }
        });

        Button about = (Button) findViewById(R.id.about);
        about.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                AlertDialog.Builder builder = new AlertDialog.Builder(MainActivity.this);

                builder.setTitle("About");
                builder.setMessage("This game was designed and developped (and maybe maintained) by sTealth studios Thanks to The VIP.\n\nEnjoy! :D")
                        .setCancelable(true)
                        .setNeutralButton("Ok", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialogInterface, int i) {
                                dialogInterface.dismiss();;
                            }
                        });


                AlertDialog alertDialog = builder.create();
                alertDialog.show();
            }
        });
        ImageButton settings = (ImageButton) findViewById(R.id.settings);
        settings.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent it = new Intent(MainActivity.this,SettingsActivity.class);
                startActivity(it);
            }
        });
        MobileAds.initialize(this,"ca-app-pub-6136998548207096~6232367406");
        AdView adview = new AdView(this);//(AdView) findViewById(R.id.adView_Main);
        AdRequest adRequest = new AdRequest.Builder()
       //         .addTestDevice(AdRequest.DEVICE_ID_EMULATOR)

                .build();
        adview.setAdSize(AdSize.BANNER);
        adview.setAdUnitId("ca-app-pub-6136998548207096/8471517937");
        adview.loadAd(adRequest);
   //     RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.MATCH_PARENT);
        adContainer.addView(adview);
    }
    public void loadTheGuns(int index)
    {

        Log.e("LOADING GUNS","starting...");
        Cursor c1=null;
        Cursor c2=null;
        if(index==1){
            Log.e("LOADING GUNS","index 1");
            c1 = dbhelper.query("SELECT * FROM beginner");
            c2 = dbhelper.query("SELECT * FROM side_dares WHERE level=1");
            Log.e("LOADING GUNS","query done");
        }
        else if(index==2) {
            Log.e("LOADING GUNS","index 2");
            c1 = dbhelper.query("SELECT * FROM intermediate");
            c2 = dbhelper.query("SELECT * FROM side_dares WHERE level=2");
            Log.e("LOADING GUNS","query done");
        }
        else {
            Log.e("LOADING GUNS","index 3");
            c1 = dbhelper.query("SELECT * FROM Hmf");
            c2 = dbhelper.query("SELECT * FROM side_dares WHERE level=3");
            Log.e("LOADING GUNS","query done");
        }
        if(c1.isBeforeFirst())
            c1.moveToFirst();
        if(c2.isBeforeFirst())
            c2.moveToFirst();
        Log.e("LOADING GUNS","starting orders");
        while(!c1.isAfterLast()) {

            String text=c1.getString(c1.getColumnIndex("text"));
            String subtext=c1.getString(c1.getColumnIndex("subtext"));
            String type=c1.getString(c1.getColumnIndex("type"));
            int amount = c1.getInt(c1.getColumnIndex("amount"));
            Log.e("LOADING GUNS",text);
            createOrder(text,subtext,type,amount);
            c1.moveToNext();
        }
        while(!c2.isAfterLast()) {

            String text=c2.getString(c2.getColumnIndex("text"));
            String subtext=c2.getString(c2.getColumnIndex("subtext"));
            String type=c2.getString(c2.getColumnIndex("type"));
            int amount = c2.getInt(c2.getColumnIndex("amount"));
            Log.e("LOADING GUNS",text);
            createOrder(text,subtext,type,amount);
            c2.moveToNext();
        }

    }
    public void createOrder(String text,String sub,String type,int amount)
    {
        String[] texts = text.split("~");
        if(texts.length>1)
        {
            for(int i=0;i<texts.length-1;i++)
                text=texts[i]+"\n";
            text+=texts[texts.length-1];
        }

        if(sub==null||sub.length()==0)
            sub=" ";
        String actualamount="";

        if(amount==1)
            actualamount="1 shot";
        else if(amount<=4&&amount>1){
            actualamount=amount+" shots";
        }
        else{
            if(amount==5)
                actualamount="1 Full cup";
            else
                actualamount="2 Full cups";
        }



        Order o = new Order(text,sub,type,actualamount);

        if(o.getType().equalsIgnoreCase("Dare"))
            dares.add(o);
        else{
            wildCards.add(o);
        }


    }

    @Override
    protected void onResume() {
        super.onResume();
        dares = new ArrayList<Order>();
        wildCards = new ArrayList<Order>();
        isStarting=false;
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if(requestCode==REQUESTING){
            if(grantResults[0]== PackageManager.PERMISSION_GRANTED&&grantResults[1]==PackageManager.PERMISSION_GRANTED){
                if(isStarting){
                    final Button start = (Button) findViewById(R.id.startttt);
                    start.performClick();
                }

            }
            else{
                Toast.makeText(MainActivity.this,"Storage permission is essential for this Application to run",Toast.LENGTH_LONG).show();
            }
        }

    }
}
