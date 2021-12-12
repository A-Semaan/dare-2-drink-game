package com.studios.stealth.dare2drinkFree;

import android.database.Cursor;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;

import java.io.IOException;

public class EditSideDareActivity extends AppCompatActivity {

    DataBaseHelper dbhelper;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_side_dare);
        dbhelper = new DataBaseHelper(this);
        try {
            dbhelper.createDataBase();
            dbhelper.openDataBase();
        } catch (IOException e) {
            e.printStackTrace();
        }
        Bundle b = this.getIntent().getBundleExtra("bundle");
        final int id=b.getInt("iid");
        Cursor c = dbhelper.query("SELECT * FROM side_dares WHERE _id="+id);
        c.moveToFirst();
        final EditText text = (EditText) findViewById(R.id.edit_side_dare_text);
        final EditText subtext = (EditText) findViewById(R.id.edit_side_dare_subtext);
        final Spinner type = (Spinner) findViewById(R.id.edit_side_dare_type);
        final Spinner level = (Spinner) findViewById(R.id.edit_side_dare_level);
        final Spinner amount = (Spinner) findViewById(R.id.edit_side_dare_amount);
        text.setText(c.getString(c.getColumnIndex("text")));
        subtext.setText(c.getString(c.getColumnIndex("subtext")));
        if(c.getString(c.getColumnIndex("type")).equals("DARE")){
            type.setSelection(1);
        }
        else{
            type.setSelection(2);
        }
        level.setSelection(c.getInt(c.getColumnIndex("level")));

        amount.setSelection(c.getInt(c.getColumnIndex("amount")));


        Button editsave = (Button) findViewById(R.id.edit_save);
        editsave.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(everythingisfine()){
                    String typetoenter=type.getSelectedItemPosition()==1?"DARE":"GENERIC";
                    dbhelper.update("UPDATE side_dares SET text=\""+text.getText()+"\", subtext=\""+subtext.getText()+"\", type=\""+typetoenter+"\", " +
                            "level="+level.getSelectedItemPosition()+",amount="+amount.getSelectedItemPosition()+" WHERE _id="+id);
                    EditSideDareActivity.this.finish();
                }
                else{
                    Toast.makeText(EditSideDareActivity.this, "One or more fields are invalid", Toast.LENGTH_SHORT).show();
                }
            }
        });
    }
    public boolean everythingisfine(){
        EditText text = (EditText) findViewById(R.id.edit_side_dare_text);
        Spinner type = (Spinner) findViewById(R.id.edit_side_dare_type);
        Spinner level = (Spinner) findViewById(R.id.edit_side_dare_level);
        Spinner amount = (Spinner) findViewById(R.id.edit_side_dare_amount);
        if(!text.getText().equals("")&&type.getSelectedItemPosition()!=0&&level.getSelectedItemPosition()!=0&&amount.getSelectedItemPosition()!=0){
            return true;
        }
        return false;
    }
}
