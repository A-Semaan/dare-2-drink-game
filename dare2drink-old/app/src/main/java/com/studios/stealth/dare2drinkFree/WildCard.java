package com.studios.stealth.dare2drinkFree;

import android.content.Context;
import android.util.Log;
import android.view.GestureDetector;
import android.widget.TextView;

import com.mindorks.placeholderview.SwipePlaceHolderView;
import com.mindorks.placeholderview.annotations.Layout;
import com.mindorks.placeholderview.annotations.Resolve;
import com.mindorks.placeholderview.annotations.swipe.SwipeCancelState;
import com.mindorks.placeholderview.annotations.swipe.SwipeIn;
import com.mindorks.placeholderview.annotations.swipe.SwipeInState;
import com.mindorks.placeholderview.annotations.swipe.SwipeOut;
import com.mindorks.placeholderview.annotations.swipe.SwipeOutState;

@Layout(R.layout.card_layout)
public class WildCard{

    @com.mindorks.placeholderview.annotations.View(R.id.wildtext)
    private TextView wildtext;

    @com.mindorks.placeholderview.annotations.View(R.id.wildtextshots)
    private TextView wildtextshots;

    @com.mindorks.placeholderview.annotations.View(R.id.subtextwild)
    private TextView subtextwild;

    private Order wildcard;

    private Context mContext;
    private SwipePlaceHolderView mSwipeView;

    GestureDetector gestureDetector;
    android.view.View.OnTouchListener gestureListener;


    public WildCard(Context context,Order ord, SwipePlaceHolderView swipeView) {
        mContext = context;
        wildcard = ord;
        mSwipeView = swipeView;
        Log.d("LLLLLLLLLLLLL",wildcard.getText());


    }

    @Resolve
    private  void  onResolve()
    {
        Log.d("EVENT", "onResolveWild");
        try{
            if(wildcard!=null) {
                wildtext.setText(wildcard.getText());
                subtextwild.setText(wildcard.getSubText());
                if (!wildcard.getDifficulty().equals("0"))
                    wildtextshots.setText(wildcard.getDifficulty());
            }
        }
        catch (Exception e)
        {
            Log.d("my log","stacktrace",e);
            wildtext.setText(insideGame.o.getText());
            subtextwild.setText(insideGame.o.getSubText());
            if (!insideGame.o.getDifficulty().equals("0"))
                wildtextshots.setText(insideGame.o.getDifficulty());
            System.out.println("in here");
        }
    }

    @SwipeOut
    private void onSwipedOut(){
        Log.d("EVENT", "onSwipedOut");
        insideGame.mSwipeViewwild =null;
        insideGame.wildcount=0;

    }

    @SwipeCancelState
    private void onSwipeCancelState(){
        Log.d("EVENT", "onSwipeCancelState");
    }

    @SwipeIn
    private void onSwipeIn(){

        Log.d("EVENT", "onSwipedIn");
        insideGame.mSwipeViewwild =null;
        insideGame.wildcount=0;
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
