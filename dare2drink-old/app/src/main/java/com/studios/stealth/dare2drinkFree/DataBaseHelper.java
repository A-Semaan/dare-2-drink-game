package com.studios.stealth.dare2drinkFree;

/**
 * Created by Semaan on 10/10/2018.
 */

import android.content.Context;
import android.database.Cursor;
import android.database.SQLException;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.os.Environment;
import android.util.Log;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import static android.content.ContentValues.TAG;

/**
 * Created by Semaan on 6/10/2018.
 */

public class DataBaseHelper extends SQLiteOpenHelper {

    //The Android's default system path of your application database.
    private static String DB_PATH = "";

    private static String DB_NAME = "dare2drink.db";

    private SQLiteDatabase myDataBase;

    private final Context myContext;

    /**
     * Constructor
     * Takes and keeps a reference of the passed context in order to access to the application assets and resources.
     * @param context
     */
    public DataBaseHelper(Context context) {

        super(context, DB_NAME, null, 1);
        this.myContext = context;
      /*  if(android.os.Build.VERSION.SDK_INT >= 17){
            DB_PATH = context.getApplicationInfo().dataDir + "/databases/";
        }
        else
        {
            DB_PATH = "/data/data/" + context.getPackageName() + "/databases/";
        }*/
        DB_PATH= context.getCacheDir().getAbsolutePath();
        System.out.println("PATH IS"+ DB_PATH);

    }

    /**
     * Creates a empty database on the system and rewrites it with your own database.
     * */
    public void createDataBase() throws IOException {

        boolean dbExist = checkDataBase();

        if(dbExist){
            //do nothing - database already exist
        }else{

            //By calling this method and empty database will be created into the default system path
            //of your application so we are gonna be able to overwrite that database with our database.
           // this.getWritableDatabase();

            try {

                copyDataBase();

            } catch (IOException e) {

                e.printStackTrace();
                //throw new Error("Error copying database");

            }
        }

    }

    /**
     * Check if the database already exist to avoid re-copying the file each time you open the application.
     * @return true if it exists, false if it doesn't
     */
    private boolean checkDataBase(){

        SQLiteDatabase checkDB = null;

        try{
            String myPath = DB_PATH + DB_NAME;
            File f = new File(myPath);
            System.out.println("File does exist:"+f.exists());
            f.delete();
            checkDB = SQLiteDatabase.openDatabase(myPath, null, SQLiteDatabase.OPEN_READWRITE);

        }catch(Exception e){



        }

        if(checkDB != null){

            checkDB.close();

        }

        return checkDB != null ? true : false;
    }

    /**
     * Copies your database from your local assets-folder to the just created empty database in the
     * system folder, from where it can be accessed and handled.
     * This is done by transfering bytestream.
     * */
    private void copyDataBase() throws IOException {

        //Open your local db as the input stream
        InputStream myInput = myContext.getAssets().open(DB_NAME);

        // Path to the just created empty db
        String outFileName = DB_PATH + DB_NAME;

        File f = new File (outFileName);
        f.createNewFile();

        //Open the empty db as the output stream
        OutputStream myOutput = new FileOutputStream(f);

        //transfer bytes from the inputfile to the outputfile
        byte[] buffer = new byte[1024];
        int length;
        while ((length = myInput.read(buffer))>0){
            myOutput.write(buffer, 0, length);
            Log.e("status","copying");
        }
        Log.e("status","database copied");
        //Close the streams
        myOutput.flush();
        myOutput.close();
        myInput.close();

    }
    public void copyDatabase(String s) throws IOException{
        InputStream myInput = new FileInputStream(new File(s));

        // Path to the just created empty db
        String outFileName = DB_PATH + DB_NAME;

        //Open the empty db as the output stream
        OutputStream myOutput = new FileOutputStream(outFileName);

        //transfer bytes from the inputfile to the outputfile
        byte[] buffer = new byte[1024];
        int length;
        while ((length = myInput.read(buffer))>0){
            myOutput.write(buffer, 0, length);
        }

        //Close the streams
        myOutput.flush();
        myOutput.close();
        myInput.close();
    }

    public void copyBackupDatabase(String s)throws IOException{
        //Open your local db as the input stream
        InputStream myInput = myContext.getAssets().open(s);

        // Path to the just created empty db
        String outFileName = DB_PATH + DB_NAME;

        //Open the empty db as the output stream
        OutputStream myOutput = new FileOutputStream(outFileName);

        //transfer bytes from the inputfile to the outputfile
        byte[] buffer = new byte[1024];
        int length;
        while ((length = myInput.read(buffer))>0){
            myOutput.write(buffer, 0, length);
        }

        //Close the streams
        myOutput.flush();
        myOutput.close();
        myInput.close();
    }

    public void openDataBase() throws SQLException {

        //Open the database
        String myPath = DB_PATH + DB_NAME;
        myDataBase = SQLiteDatabase.openDatabase(myPath, null, SQLiteDatabase.OPEN_READWRITE);
        System.out.println();
    }

    @Override
    public synchronized void close() {

        if(myDataBase != null)
            myDataBase.close();

        super.close();

    }

    @Override
    public void onCreate(SQLiteDatabase db) {

    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

    }

    public Cursor query(String sql)
    {
        try
        {

            return myDataBase.rawQuery(sql, null);
        }
        catch (SQLException mSQLException)
        {
            Log.e(TAG, "getTestData >>"+ mSQLException.toString());
            throw mSQLException;
        }
    }

    public void update(String sql)
    {
        try
        {

            myDataBase.execSQL(sql);

        }
        catch (SQLException mSQLException)
        {
            Log.e(TAG,
                    mSQLException.toString());
            throw mSQLException;
        }
    }

    public String getDatabasePath(){
        return DB_PATH+DB_NAME;
    }
    public String getDatabaseName(){ return DB_NAME; }

    // Add your public helper methods to access and get content from the database.
    // You could return cursors by doing "return myDataBase.query(....)" so it'd be easy
    // to you to create adapters for your views.
    public void export(){
        File internalStroage = Environment.getExternalStorageDirectory();
        internalStroage.setWritable(true);
        File dare2drink = new File(internalStroage.getAbsolutePath()+"/Dare2Drink");
        File db;
        if(dare2drink.exists()){
            db=new File(dare2drink.getAbsolutePath()+"/Dare2Drink.db");
            if(db.exists()){
                try {
                    db.createNewFile();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

        }
        else{
            dare2drink.mkdir();
            db=new File(dare2drink.getAbsolutePath()+"/Dare2Drink.db");
            try {
                db.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        try {
            OutputStream os = new BufferedOutputStream(new FileOutputStream(db));
            InputStream is = new BufferedInputStream(new FileInputStream(DB_PATH+DB_NAME));
            byte[] buffer = new byte[1024];
            int length;
            while ((length = is.read(buffer))>0){
                Log.d("EXPORTING DB","WRITING...");
                os.write(buffer, 0, length);
            }
            Log.d("EXPORTING DB","FLUSHING...");
            os.flush();
            Log.d("EXPORTING DB","CLOSING OS...");
            os.close();
            Log.d("EXPORTING DB","CLOSING IS...");
            is.close();
            Log.d("EXPORTING DB","MAKING TOAST...");

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

