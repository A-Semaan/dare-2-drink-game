package com.studios.stealth.dare2drinkFree;

import android.app.Activity;
import android.app.DownloadManager;
import android.app.ProgressDialog;
import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.database.Cursor;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.support.v7.app.AlertDialog;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.SeekBar;
import android.widget.TextView;
import android.widget.Toast;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

public class SettingsActivity extends Activity {

    private static long dbvID;
    private static long dbID;

    static DownloadManager dm;
    private BroadcastReceiver br;

    private static ProgressDialog checkingdialog;

    private DataBaseHelper dbhelper;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_settings);
        dbhelper = new DataBaseHelper(this);

        try {
            dbhelper.createDataBase();
            dbhelper.openDataBase();
        } catch (IOException e) {
            e.printStackTrace();
        }

        final Button apply = (Button) findViewById(R.id.apply_settings);
        final TextView tv = (TextView) findViewById(R.id.settingsWildCardTextView);
        final SeekBar sb = (SeekBar) findViewById(R.id.settingsWildCardSeekBar);
        final LinearLayout sideDaresLayout = (LinearLayout) findViewById(R.id.manageSideDares);
        final LinearLayout checkForUpdates = (LinearLayout) findViewById(R.id.checkForUpdates);

        final String wildcard="WildCard Chance: ";
        checkingdialog = new ProgressDialog(this);
        checkingdialog.setCanceledOnTouchOutside(false);
        checkingdialog.setTitle("Checking For Updates");
        checkingdialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
        checkingdialog.setIndeterminate(true);
        dm = (DownloadManager) this.getSystemService(Service.DOWNLOAD_SERVICE);
        br = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                String action = intent.getAction();
                if(DownloadManager
                        .ACTION_DOWNLOAD_COMPLETE.equals(action)){
                    DownloadManager.Query query = new DownloadManager.Query();
                    query.setFilterById(dbvID);
                    Cursor c = dm.query(query);
                    if(c.moveToFirst()){
                        int colindex = c.getColumnIndex(DownloadManager.COLUMN_STATUS);
                        if(DownloadManager.STATUS_SUCCESSFUL==c.getInt(colindex)){
                            checkDBV();
                        }
                    }
                    else{
                        query.setFilterById(dbID);
                        Cursor c1 = dm.query(query);
                        c.moveToFirst();
                        int colindex = c.getColumnIndex(DownloadManager.COLUMN_STATUS);
                        if(DownloadManager.STATUS_SUCCESSFUL==c.getInt(colindex)){
                            String path = SettingsActivity.this.getCacheDir()+File.separator+"dare2drink.db";
                            try {
                                dbhelper.copyDatabase(path);
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                            Toast.makeText(SettingsActivity.this,"Database updated, retarting...",Toast.LENGTH_SHORT).show();
                            Intent i = getBaseContext().getPackageManager()
                                    .getLaunchIntentForPackage( getBaseContext().getPackageName() );
                            i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                            startActivity(i);
                        }
                    }
                }
            }
        };

        tv.setText("WildCard Chance: "+MainActivity.proba+"%");
        sb.setProgress(MainActivity.proba/10);
        sb.setMax(10);

        sb.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int i, boolean b) {
                if (MainActivity.proba/10==i){
                    apply.setVisibility(View.GONE);
                }
                else{
                    apply.setVisibility(View.VISIBLE);
                }
                tv.setText(wildcard+(sb.getProgress()*10)+"%");
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {

            }
        });

        sideDaresLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent it = new Intent(SettingsActivity.this,ManageSideDaresActivity.class);
                startActivity(it);
            }
        });

        apply.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                try {
                    File f = new File(SettingsActivity.this.getFilesDir(),"proba.txt");
                    f.createNewFile();
                    FileWriter fw = new FileWriter(f);
                    fw.write((sb.getProgress()*10)+"");
                    fw.flush();
                    fw.close();
                    MainActivity.proba=sb.getProgress()*10;
                    SettingsActivity.this.finish();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        });
        checkForUpdates.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Toast.makeText(SettingsActivity.this, "Coming soon ...", Toast.LENGTH_SHORT).show();
                /*checkingdialog.show();
                checkForUpdates();*/
            }
        });
        registerReceiver(br,new IntentFilter(DownloadManager.ACTION_DOWNLOAD_COMPLETE));
    }
    public void checkForUpdates(){
        ConnectivityManager connManager = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo mWifi = connManager.getNetworkInfo(ConnectivityManager.TYPE_WIFI);

        if (mWifi.isConnected()) {
            File f=null;
            try {
                f = File.createTempFile("dbv",".txt",this.getCacheDir());
            } catch (IOException e) {
                e.printStackTrace();
            }

            DownloadManager.Request rqt= new DownloadManager.Request(Uri.parse("https://drive.google.com/open?id=1ZwZWW-LP8WjE1nJu4K0aA5RlO2h8WJrR"));
            rqt.setVisibleInDownloadsUi(false);
            rqt.setDestinationInExternalFilesDir(this,f.getAbsolutePath(),null);
            dbvID = dm.enqueue(rqt);

        }
        else{
            checkingdialog.dismiss();
            Toast.makeText(this, "Please connect to a wifi first", Toast.LENGTH_SHORT).show();

        }
    }
    public void checkDBV(){
        File f= new File(this.getCacheDir()+File.separator+"dbv.txt");
        double d=0;
        try {
            d = Double.parseDouble( new BufferedReader(new FileReader(f)).readLine());
        } catch (IOException e) {
            e.printStackTrace();
        }
        InputStream is=null;
        double dd=0;
        try {
            is = this.getAssets().open("databaseVersion");
            dd = Double.parseDouble(new BufferedReader(new InputStreamReader(is)).readLine());
        } catch (IOException e) {
            e.printStackTrace();
        }
        checkingdialog.dismiss();
        if(d!=dd){
            AlertDialog.Builder b = new AlertDialog.Builder(this);
            b.setCancelable(true)
                    .setMessage("A new database is available would you like to update it?")
                    .setTitle("Upadte database")

                    .setPositiveButton("Yes", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialogInterface, int i) {

                            ConnectivityManager connManager = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
                            NetworkInfo mWifi = connManager.getNetworkInfo(ConnectivityManager.TYPE_WIFI);

                            if (mWifi.isConnected()) {
                                File f=null;
                                try {
                                    f = File.createTempFile("dare2drink",".db",SettingsActivity.this.getCacheDir());
                                } catch (IOException e) {
                                    e.printStackTrace();
                                }

                                DownloadManager.Request rqt= new DownloadManager.Request(Uri.parse("https://drive.google.com/open?id=1bMgsW2ACRTwQP-NV3QIvVqSu8Jbm8U8k"));
                                rqt.setVisibleInDownloadsUi(true);
                                rqt.setDestinationInExternalFilesDir(SettingsActivity.this,f.getAbsolutePath(),null);
                                dbID = dm.enqueue(rqt);

                            }
                        }
                    })
                    .setNegativeButton("No", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialogInterface, int i) {
                            dialogInterface.dismiss();
                        }
                    }).show();
        }
        else{
            Toast.makeText(this, "Your database is up to date!", Toast.LENGTH_SHORT).show();
        }

    }
}
