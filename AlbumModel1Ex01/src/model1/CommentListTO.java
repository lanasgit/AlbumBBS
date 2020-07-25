package model1;

import java.util.ArrayList;

public class CommentListTO {
	
	private String seq;
	private ArrayList<CommentTO> cboardLists;
	
	public String getSeq() {
		return seq;
	}
	public void setSeq(String seq) {
		this.seq = seq;
	}
	public ArrayList<CommentTO> getCboardLists() {
		return cboardLists;
	}
	public void setCboardLists(ArrayList<CommentTO> cboardLists) {
		this.cboardLists = cboardLists;
	}
	
}
