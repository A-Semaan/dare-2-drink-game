package com.studios.stealth.dare2drinkFree;

import java.io.Serializable;

/**
 * Created by Semaan on 1/5/2018.
 */

public class Order implements Serializable{
    private String text;
    private String subText;
    private String type;
    private String difficulty;

    public Order(String t,String s,String ty,String d)
    {
        text=t;
        subText=s;
        type=ty;
        difficulty=d;
    }

    public String getText()
    {return text;}

    public String getSubText()
    {return subText;}

    public String getType()
    {return type;}

    public String getDifficulty()
    {return difficulty;}

}
