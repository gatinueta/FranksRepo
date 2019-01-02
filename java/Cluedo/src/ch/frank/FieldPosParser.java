package ch.frank;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class FieldPosParser {
	private Gson gson = new GsonBuilder().setPrettyPrinting().create();
	public RawFieldPosInfo fromJson() {
		InputStream fieldsStream = getClass().getResourceAsStream("fields.json");
		Reader reader = new InputStreamReader(fieldsStream);
		RawFieldPosInfo result  = gson.fromJson(reader, RawFieldPosInfo.class);
		return result;
	}
	public void toJson() {
		System.out.println(gson.toJson(RawFieldPosInfo.getExampleInstance()));
		
	}
}
