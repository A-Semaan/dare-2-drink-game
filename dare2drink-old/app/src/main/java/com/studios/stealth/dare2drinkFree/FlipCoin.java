package com.studios.stealth.dare2drinkFree;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.Random;

/**
 * Created by Semaan on 2/7/2018.
 */
public class FlipCoin extends AppCompatActivity{

    private boolean isFliping=false;
    private boolean clicked=false;
    private boolean isHeads=false;
    private ImageView coin;
    static int counter=0;
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);
        setContentView(R.layout.flip_coin_layout);
        coin = (ImageView) findViewById(R.id.coin);
        coin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(isFliping)
                {
                    clicked=true;
                    /*i*=-1;
                    x=(i*-1)%2==0?-4:-3;
                    i=0;*/
                    Random rand = new Random();
                    isHeads = (rand.nextInt(2)+1)==1?true:false;
                }
                else{
                    isFliping=true;
                    flip(1);
                }
                Log.e("FLIPPING","starting flip");


            }
        });
        coin.setLayerType(View.LAYER_TYPE_SOFTWARE,null);
    }

    private void flip(int index) {

        /*Animation shrink = AnimationUtils.loadAnimation(this, R.anim.shrink);

        if(i<=0)
        {

            shrink.setDuration(200);
            shrink.setAnimationListener(new Animation.AnimationListener() {
                @Override
                public void onAnimationStart(Animation animation) {
                    System.out.println("i is : "+i);
                }

                @Override
                public void onAnimationEnd(Animation animation) {
                    Animation grow = AnimationUtils.loadAnimation(FlipCoin.this, R.anim.grow);
                    grow.setDuration(200);
                    grow.setAnimationListener(new Animation.AnimationListener() {
                        @Override
                        public void onAnimationStart(Animation animation) {
                            if((i--*-1)%2==0)
                                coin.setImageResource(R.drawable.tails);
                            else
                                coin.setImageResource(R.drawable.heads);
                        }

                        @Override
                        public void onAnimationEnd(Animation animation) {
                            System.out.println("i is: "+i+"  x is :" +x);
                            if(i==x)
                            {
                                clicked=false;

                                isFliping=false;
                                System.out.println("returning1");
                                i=1;
                                if(x%2==0)
                                {
                                    TextView t = (TextView)findViewById(R.id.result);
                                    t.setText("It is Heads");
                                }
                                else{
                                    TextView t = (TextView)findViewById(R.id.result);
                                    t.setText("It is Tails");
                                }

                                return;
                            }
                            flip();
                        }

                        @Override
                        public void onAnimationRepeat(Animation animation) {

                        }
                    });
                    coin.startAnimation(grow);

                }

                @Override
                public void onAnimationRepeat(Animation animation) {

                }
            });
            coin.startAnimation(shrink);
            return;
        }
        shrink.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {
                System.out.println("i is : "+i);
            }

            @Override
            public void onAnimationEnd(Animation animation) {
                Animation grow = AnimationUtils.loadAnimation(FlipCoin.this, R.anim.grow);

                grow.setAnimationListener(new Animation.AnimationListener() {
                    @Override
                    public void onAnimationStart(Animation animation) {
                        if(i++%2==0)
                            coin.setImageResource(R.drawable.tails);
                        else
                            coin.setImageResource(R.drawable.heads);
                        if(i==3)
                            i=1;
                    }

                    @Override
                    public void onAnimationEnd(Animation animation) {

                        flip();
                    }

                    @Override
                    public void onAnimationRepeat(Animation animation) {

                    }
                });
                coin.startAnimation(grow);
                if(i==0&&!isFliping) {
  //                  coin.clearAnimation();
                    System.out.println("returning2");
                    return;
                }
            }

            @Override
            public void onAnimationRepeat(Animation animation) {

            }
        });

        coin.startAnimation(shrink);
        isFliping=true;
*/
        Log.e("FLIPPING","attempting to flip");
        final Animation shrink1 = AnimationUtils.loadAnimation(this, R.anim.shrink);
        final Animation grow1 = AnimationUtils.loadAnimation(FlipCoin.this, R.anim.grow);
        final Animation shrink2 = AnimationUtils.loadAnimation(this, R.anim.shrink);
        final Animation grow2 = AnimationUtils.loadAnimation(FlipCoin.this, R.anim.grow);
        if(clicked){
            grow1.setDuration(400);
            shrink1.setDuration(400);
            grow2.setDuration(400);
            shrink2.setDuration(400);;
        }
        shrink1.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {
                coin.setImageResource(R.drawable.heads);
            }

            @Override
            public void onAnimationEnd(Animation animation) {
                flip(2);
            }

            @Override
            public void onAnimationRepeat(Animation animation) {

            }
        });
        grow1.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {
                coin.setImageResource(R.drawable.tails);
            }

            @Override
            public void onAnimationEnd(Animation animation) {
                if(clicked&&counter>=2&&!isHeads){
                    TextView t = (TextView)findViewById(R.id.result);
                    t.setText("It is Tails");
                    isFliping=false;
                    clicked=false;
                    counter=0;
                    isHeads=false;
                    return;
                }
                flip(3);
            }

            @Override
            public void onAnimationRepeat(Animation animation) {

            }
        });
        shrink2.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {
                coin.setImageResource(R.drawable.tails);
            }

            @Override
            public void onAnimationEnd(Animation animation) {
                flip(4);
            }

            @Override
            public void onAnimationRepeat(Animation animation) {

            }
        });
        grow2.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {
                coin.setImageResource(R.drawable.heads);
            }

            @Override
            public void onAnimationEnd(Animation animation) {
                if(clicked&&counter>=2&&isHeads){
                    TextView t = (TextView)findViewById(R.id.result);
                    t.setText("It is Heads");
                    isFliping=false;
                    clicked=false;
                    counter=0;
                    isHeads=false;
                    return;
                }
                flip(1);
            }

            @Override
            public void onAnimationRepeat(Animation animation) {

            }
        });
        switch(index){
            case 1:coin.startAnimation(shrink1);
                break;
            case 2:coin.startAnimation(grow1);
                break;
            case 3:coin.startAnimation(shrink2);
                break;
            case 4:coin.startAnimation(grow2);
                if(clicked)counter++;
                break;
        }
    }
}