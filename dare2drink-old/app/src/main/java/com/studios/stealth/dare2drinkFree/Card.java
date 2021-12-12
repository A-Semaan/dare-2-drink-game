package com.studios.stealth.dare2drinkFree;

import android.content.Context;
import android.content.DialogInterface;
import android.support.v7.app.AlertDialog;
import android.util.Log;
import android.view.Window;
import android.view.WindowManager;
import android.widget.TextView;
import android.widget.Toast;

import com.mindorks.placeholderview.SwipePlaceHolderView;
import com.mindorks.placeholderview.annotations.Layout;
import com.mindorks.placeholderview.annotations.Resolve;
import com.mindorks.placeholderview.annotations.View;
import com.mindorks.placeholderview.annotations.swipe.SwipeCancelState;
import com.mindorks.placeholderview.annotations.swipe.SwipeIn;
import com.mindorks.placeholderview.annotations.swipe.SwipeInState;
import com.mindorks.placeholderview.annotations.swipe.SwipeOut;
import com.mindorks.placeholderview.annotations.swipe.SwipeOutState;

import java.util.Random;

import static com.studios.stealth.dare2drinkFree.insideGame.wildCards;

@Layout(R.layout.card_layout)
public class Card {

    @com.mindorks.placeholderview.annotations.View(R.id.texttext)
    private TextView texttext;

    @View(R.id.subtext)
    private TextView subtext;

    @View(R.id.diffTxt)
    private TextView difftext;

    private Order ord;

    private Context mContext;
    private SwipePlaceHolderView mSwipeView;

    public Card(Context context,Order o, SwipePlaceHolderView swipeView) {
        mContext = context;
        ord = o;
        mSwipeView = swipeView;
    }

    @Resolve
    private void onResolved(){
        Log.d("EVENT", "onResolved");
        texttext.setText(ord.getText());
        subtext.setText(ord.getSubText());
        Log.e("Difficulty",ord.getDifficulty());
        if(!ord.getDifficulty().equals("0"))
            difftext.setText("Or Take "+ord.getDifficulty()+" like a loser");

    }



    @SwipeOut
    private void onSwipedOut(){
        Log.d("EVENT", "onSwipedOut");

        mSwipeView.addView(this);

        boolean b=flipCoin();
        Log.d("EVENT", "Coin FLipped:"+b);
        Log.d("ALERT", wildCards.size()+"  && swipes:" + insideGame.swipes);
        if(b&&insideGame.swipes>7) {

            Random rand = new Random();
            int d;
            do {
                d = rand.nextInt(97);
            } while (d < 0 || d > 97);

            AlertDialog.Builder builder = new AlertDialog.Builder(mContext);
            Order o = wildCards.get(d);
            String s="";
            s=o.getDifficulty();
            builder.setMessage(o.getText()+"\n\n"+o.getSubText()+"\n\n"+s)
                    .setCancelable(false)
                    .setPositiveButton("AWESOME", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            dialog.dismiss();

                        }
                    })
                    .setNegativeButton("Didn't do it", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            dialog.dismiss();
                            Toast.makeText(mContext,"Wow you guys are fags",Toast.LENGTH_SHORT).show();

                        }
                    });


            AlertDialog alertDialog = builder.create();
            alertDialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
            alertDialog.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
            alertDialog.show();

        }
        insideGame.swipes++;
    }

    private boolean flipCoin() {
        Random rand = new Random();

        int  n = rand.nextInt(100) + 1;

        return n<=MainActivity.proba;

    }

    @SwipeCancelState
    private void onSwipeCancelState(){

        Log.d("EVENT", "onSwipeCancelState");
        Toast.makeText(mContext,"Weak..",Toast.LENGTH_SHORT).show();
    }

    @SwipeIn
    private void onSwipeIn(){

        Log.d("EVENT", "onSwipedIn");

        mSwipeView.addView(this);

        boolean b=flipCoin();
        Log.d("EVENT", "Coin FLipped:"+b);
        Log.d("ALERT", wildCards.size()+"  && swipes:" + insideGame.swipes);
        if(b&&insideGame.swipes>7&&insideGame.wildcount!=1) {

            Random rand = new Random();
            int d = rand.nextInt(wildCards.size());
            AlertDialog.Builder builder = new AlertDialog.Builder(mContext);
            Order o = wildCards.get(d);
            String s="";
            if(!o.getDifficulty().equals("0"))
                s=o.getDifficulty();
            builder.setMessage(o.getText()+"\n\n"+o.getSubText()+"\n\n"+s)
                    .setCancelable(false)
                    .setPositiveButton("AWESOME", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            dialog.dismiss();
                        }
                    })
                    .setNegativeButton("Didn't do it", new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {
                            dialog.dismiss();
                            Toast.makeText(mContext,"Wow you guys are fags",Toast.LENGTH_SHORT).show();

                        }
                    });


            AlertDialog alertDialog = builder.create();
            alertDialog.show();
        }
        insideGame.swipes++;
    }

    @SwipeInState
    private void onSwipeInState(){
        Log.d("EVENT", "onSwipeInState");
    }

    @SwipeOutState
    private void onSwipeOutState(){
        Log.d("EVENT", "onSwipeOutState");
    }
}
