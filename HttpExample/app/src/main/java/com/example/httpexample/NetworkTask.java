package com.example.httpexample;

import android.os.AsyncTask;
import android.util.Log;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class NetworkTask extends AsyncTask<String, Void, Long> {


    public NetworkTask() {

    }

    @Override
    protected void onProgressUpdate(Void... values) {
        super.onProgressUpdate(values);
    }

    @Override
    protected Long doInBackground(String... urls) {
        Log.d("Test API", "");
        String urlString = "https://dapi.kakao.com/v2/local/search/address.json?query=서울특별시 마포구 대흥로 49 금호타이어마포영업소";
        String response = "";
        try {
            URL url = new URL(urlString);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.setRequestProperty("Authorization", "KakaoAK ddb2a562456ecb98b034dcd2e566ee97");

            connection.connect();

            int responseCode = connection.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                InputStream inputStream = connection.getInputStream();
                response = readFromStream(inputStream);
                Log.d("Test API", response);
            } else {
                // Handle error
                connection.disconnect();
            }
        } catch (IOException e) {
            // Handle exception
        }
        return null;
    }

    @Override
    protected void onPostExecute(Long result) {

    }

    private String readFromStream(InputStream inputStream) throws IOException {
        StringBuilder buffer = new StringBuilder();
        BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
        String line;
        while ((line = reader.readLine()) != null) {
            buffer.append(line).append("\n");
        }
        return buffer.toString();
    }
}
