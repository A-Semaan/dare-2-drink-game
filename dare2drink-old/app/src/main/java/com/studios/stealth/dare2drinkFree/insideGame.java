package com.studios.stealth.dare2drinkFree;

import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.Toast;

import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.AdView;
import com.mindorks.placeholderview.SwipeDecor;
import com.mindorks.placeholderview.SwipePlaceHolderView;

import java.util.ArrayList;
import java.util.Collections;

public class insideGame extends AppCompatActivity {
    static Order o;
    static ArrayList<Order> dares;
    static ArrayList<Order> wildCards;
    public static int wildcount=0;
    private SwipePlaceHolderView mSwipeView;
    public static SwipePlaceHolderView mSwipeViewwild;
    private static Context mContext;
    public static int swipes=0;
    private Button coin;
    private static Toast toast;
    private LinearLayout adContainer;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);
        setContentView(R.layout.activity_inside_game);
        adContainer = findViewById(R.id.adView_Inside_Container);
        ArrayList<ArrayList<Order>> extras = (ArrayList<ArrayList<Order>>)getIntent().getSerializableExtra("extras");
        dares=extras.get(0);
        wildCards=extras.get(1);
        swipes=0;
        toast=new Toast(insideGame.this);

        Collections.shuffle(dares);
        Collections.shuffle(wildCards);
        mContext = getApplicationContext();
        mSwipeView = (SwipePlaceHolderView)findViewById(R.id.swipeView);

        coin = (Button) findViewById(R.id.Flip_Coin);
        coin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent it = new Intent(insideGame.this,FlipCoin.class);
                startActivity(it);
            }
        });

        mSwipeView.getBuilder()
                .setDisplayViewCount(3)
                .setSwipeDecor(new SwipeDecor()
                        .setPaddingTop(20)
                        .setRelativeScale(0.01f)
                        .setSwipeInMsgLayoutId(R.layout.swipe_in_msg_view)
                        .setSwipeOutMsgLayoutId(R.layout.swipe_out_msg_view));

        for(Order o:dares)
            mSwipeView.addView(new Card(this,o,mSwipeView));



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

    public static void addWildCard(int i)
    {
       /* mSwipeViewwild=mSwipeViewwildtemp;
        o = wildCards.get(i);
        if(o==null)
            Log.d("NULL REPORT","NULLLLLLLLLLLLLLLLLLLLL");
        WildCard w=new WildCard(mContext, o, mSwipeViewwild);
        if(w==null)
            Log.d("NULL REPORT","w is NULLLLLLLLLLLLLLLLLLLLL");
        if(mContext==null)
            Log.d("NULL REPORT","mcontect is NULLLLLLLLLLLLLLLLLLLLL");
        if(o==null)
            Log.d("NULL REPORT","o is NULLLLLLLLLLLLLLLLLLLLL");
        if(mSwipeViewwild==null)
            Log.d("NULL REPORT","mswipeview is NULLLLLLLLLLLLLLLLLLLLL");
        mSwipeViewwild.addView(w);
        */

    }

    @Override
    public void onBackPressed() {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);

        builder.setTitle("Leaving already");
        builder.setMessage("Partyy pooper Boooooooo")
                .setCancelable(false)
                .setPositiveButton("Still leavng", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        insideGame.this.finish();
                    }
                })
                .setNegativeButton("WTF No", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        dialog.cancel();
                        return;
                    }
                });


        AlertDialog alertDialog = builder.create();
        alertDialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        alertDialog.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
        alertDialog.show();
    }
}
