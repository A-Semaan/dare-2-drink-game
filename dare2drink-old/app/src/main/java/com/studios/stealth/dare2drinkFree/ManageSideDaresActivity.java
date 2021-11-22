package com.studios.stealth.dare2drinkFree;

import android.content.DialogInterface;
import android.content.Intent;
import android.database.Cursor;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.SimpleCursorAdapter;
import android.widget.TextView;
import android.widget.Toast;

import java.io.IOException;

public class ManageSideDaresActivity extends AppCompatActivity {

    DataBaseHelper dbhelper;
    SimpleCursorAdapter sca;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_manage_side_dares);
        dbhelper = new DataBaseHelper(this);
        try{
            dbhelper.createDataBase();
            dbhelper.openDataBase();
        } catch (IOException e) {
            e.printStackTrace();
        }

        Cursor c = dbhelper.query("SELECT _id, text FROM side_dares");
        ListView lv = (ListView) findViewById(R.id.side_dares_listview);
        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.addSideDare);
        sca = new SimpleCursorAdapter(this,R.layout.side_dare_view,c,new String[]{"_id","text"},new int[]{R.id.side_dare_id,R.id.side_dare_text});
        lv.setAdapter(sca);
        lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                int iid = Integer.parseInt(((TextView)view.findViewById(R.id.side_dare_id)).getText().toString());
                Intent it = new Intent(ManageSideDaresActivity.this,EditSideDareActivity.class);
                Bundle b = new Bundle();
                b.putInt("iid",iid);
                it.putExtra("bundle",b);
                startActivity(it);
            }
        });
        lv.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
            @Override
            public boolean onItemLongClick(AdapterView<?> adapterView, final View view, int i, long l) {
                new AlertDialog.Builder(ManageSideDaresActivity.this)
                        .setTitle("Confirm Delete")
                        .setMessage("Do you really want to delete this dare?")
                        .setIcon(android.R.drawable.ic_dialog_alert)
                        .setPositiveButton(android.R.string.yes, new DialogInterface.OnClickListener() {

                            public void onClick(DialogInterface dialog, int whichButton) {
                                int deleteid = Integer.parseInt(((TextView)view.findViewById(R.id.side_dare_id)).getText().toString());
                                dbhelper.update("DELETE FROM side_dares WHERE _id="+deleteid);
                                ManageSideDaresActivity.this.onResume();
                                Toast.makeText(ManageSideDaresActivity.this, "Done", Toast.LENGTH_SHORT).show();

                            }})
                        .setNegativeButton(android.R.string.no, null).show();
                return true;
            }
        });
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent it= new Intent(ManageSideDaresActivity.this,AddSideDareActivity.class);
                startActivity(it);
            }
        });

    }

    @Override
    protected void onResume() {
        super.onResume();
        Cursor c = dbhelper.query("SELECT _id, text FROM side_dares");
        sca.swapCursor(c);
    }
}
