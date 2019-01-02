package ch.frank;

import java.util.ArrayList;
import java.util.List;

public class RawFieldPosInfo {
	static class FieldPos {
		String name;
		FieldType type = FieldType.NORMAL;
		int x;
		int y;
		Integer width;
		Integer height;
	}
	static class Vertex {
		Vertex(String fromField, String toField) {
			this.fromField = fromField;
			this.toField = toField;
		}
		String fromField;
		String toField;
	}
	List<RawFieldPosInfo.FieldPos> pos = new ArrayList<>();
	List<RawFieldPosInfo.Vertex> transitions = new ArrayList<>();
	static RawFieldPosInfo getExampleInstance() {
		RawFieldPosInfo fieldPosInfo = new RawFieldPosInfo();
		List<RawFieldPosInfo.FieldPos> fp = fieldPosInfo.pos;
		RawFieldPosInfo.FieldPos p = new FieldPos();
		p.name = "MR_PEACOCK";
		p.type = FieldType.PERSON_START;
		p.x = 10;
		p.y = 10;
		fp.add(p);
		
		p = new FieldPos();
		p.name = "KITCHEN";
		p.type = FieldType.ROOM;
		p.x = 100;
		p.y = 100;
		fp.add(p);
		
		p = new FieldPos();
		p.name = "A1";
		p.x = 12;
		p.y = 12;
		fp.add(p);
		
		fieldPosInfo.transitions.add(new Vertex("KITCHEN", "MR_PEACOCK"));
		fieldPosInfo.transitions.add(new Vertex("KITCHEN", "A1"));
		
		return fieldPosInfo;
	}
}