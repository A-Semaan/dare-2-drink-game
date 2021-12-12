package com.studios.stealth.dare2drinkFree;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;

import java.io.IOException;

public class AddSideDareActivity extends AppCompatActivity {

    DataBaseHelper dbhelper;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_side_dare);

        dbhelper = new DataBaseHelper(this);
        try {
            dbhelper.createDataBase();
            dbhelper.openDataBase();
        } catch (IOException e) {
            e.printStackTrace();
        }
        final EditText text = (EditText) findViewById(R.id.add_side_dare_text);
        final EditText subtext = (EditText) findViewById(R.id.add_side_dare_subtext);
        final Spinner type = (Spinner) findViewById(R.id.add_side_dare_type);
        final Spinner level = (Spinner) findViewById(R.id.add_side_dare_level);
        final Spinner amount = (Spinner) findViewById(R.id.add_side_dare_amount);
        Button addsave = (Button) findViewById(R.id.add_save);
        addsave.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(everythingisfine()){
                    String typetoenter=type.getSelectedItemPosition()==1?"DARE":"GENERIC";
                    dbhelper.update("INSERT INTO side_dares VALUES (null,\""+text.getText()+"\", \""+subtext.getText()+"\",\""+typetoenter+"\", " +
                            ""+level.getSelectedItemPosition()+","+ amount.getSelectedItemPosition()+")");
                    AddSideDareActivity.this.finish();
                }
                else{
                    Toast.makeText(AddSideDareActivity.this, "One or more fields are invalid", Toast.LENGTH_SHORT).show();
                }
            }
        });
    }
    public boolean everythingisfine(){
        EditText text = (EditText) findViewById(R.id.add_side_dare_text);
        Spinner type = (Spinner) findViewById(R.id.add_side_dare_type);
        Spinner level = (Spinner) findViewById(R.id.add_side_dare_level);
        Spinner amount = (Spinner) findViewById(R.id.add_side_dare_amount);
        if(!text.getText().equals("")&&type.getSelectedItemPosition()!=0&&level.getSelectedItemPosition()!=0&&amount.getSelectedItemPosition()!=0){
            return true;
        }
        return false;
    }
}
