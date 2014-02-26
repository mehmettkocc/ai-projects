import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.Reader;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Random;

import org.tartarus.snowball.SnowballStemmer;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class BOWExtractor {

	static HashSet<String> dict = new HashSet<String>();
	static String[] stopwords ={"a", "about", "above", "across", "after", "afterwards", "all", "almost", 
		"along", "already", "also","am","among", "amongst", "amoungst", "an", "and", 
		"another", "any","anyhow","anyone","anything","anyway", "anywhere", "are", "around", "as",  "at", "back","be","became", 
		"because","been", "before", "beforehand", "beside", "besides", 
		"between", "both","but", "by",
		"during", "each", "eg","either","else",
		"elsewhere","enough", "etc", 
		"for", "from", "have", "he", "hence", "her", "here", "hereafter", "hereby", "herein", "hereupon", "hers", "herself", 
		"him", "himself", "his", "how", "however", "ie", "if", "in", "inc", "indeed", "into", 
		"is", "it", "its", "itself", "latter", "latterly", "ltd", 
		"me", "meanwhile", "mine", "moreover", "most", "mostly", 
		"my", "myself", "namely", "nevertheless", "now", "of", "off", "often", "on","onto", 
		"or", "otherwise", "our", "ours", "ourselves", "out", "own","per", "perhaps",
		"rather", "re", "same", "she",
		"since", "so", "some", "somehow", "someone", "something", 
		"sometime", "sometimes", "somewhere", "that", "the", "their", 
		"them", "themselves", "then", "thence", "there", "thereafter", "thereby", "therefore", "therein", "thereupon", 
		"these", "they", "this", "those", "through", "throughout", "thru", 
		"thus", "to", "together", "too", "toward", "towards", "until", 
		"upon", "us", "very", "via", "was", "we", "were", "what", "whatever", "when", "whence", "whenever",
		"where", "whereafter", "whereas", "whereby", "wherein", "whereupon", "wherever", "whether", "which", "while", 
		"whither", "who", "whoever", "whom", "whose", "why", "will", "with", "within", "without", "would", "yet",
		"you", "your", "yours", "yourself", "yourselves","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
		".","!","@","#","$","%","^","&","*","(",")","{","}","[","]",":",";",",","<",".",">","/","?","_","-","+","=",
		"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
		"http://","km","miles"};

	public static void main(String args[]) throws ClassNotFoundException, InstantiationException, IllegalAccessException, IOException{

		//				populateReviews();
		//				stemmer();
		populateDict();
		dict.remove("");
		for (Iterator<String> i = dict.iterator(); i.hasNext();) {
			String element = i.next();
			System.out.println(element);
			if (element.length()==1) {
				i.remove();
			}
		}
		prepareTrainMat();
		prepareValMat();
		prepareTestMat();
	}

	private static void stemmer() throws ClassNotFoundException, InstantiationException, IllegalAccessException, IOException {
		Class stemClass = Class.forName("org.tartarus.snowball.ext.englishStemmer");
		SnowballStemmer stemmer = (SnowballStemmer) stemClass.newInstance();

		Reader reader;
		reader = new InputStreamReader(new FileInputStream("onlyReviewsTest.txt"));
		reader = new BufferedReader(reader);

		StringBuffer input = new StringBuffer();

		OutputStream outstream = new FileOutputStream("stemmedTest.txt");

		Writer output = new OutputStreamWriter(outstream);
		output = new BufferedWriter(output);

		int repeat = 1;

		Object [] emptyArgs = new Object[0];
		int character;
		while ((character = reader.read()) != -1) {
			char ch = (char) character;
			if(ch == '\n')
				output.write('\n');
			else if (ch == ' ')
				output.write(' ');
			if (Character.isWhitespace((char) ch)) {
				if (input.length() > 0) {
					stemmer.setCurrent(input.toString());
					for (int i = repeat; i != 0; i--) {
						stemmer.stem();
					}
					output.write(stemmer.getCurrent());
					input.delete(0, input.length());
				}
			} else {
				input.append(Character.toLowerCase(ch));
			}
		}
		output.flush();
	}

	private static void populateDict(){
		try{
			BufferedReader reader = new BufferedReader(new FileReader("stemmedTrain.txt"));//form dictionary from training data only
			String line = null;
			while ((line = reader.readLine()) != null) {
				String arr[] = line.split(" ");
				for (int i = 0; i < arr.length; i++) {
					if(!dict.contains(arr[i]))
						dict.add(arr[i]);
				}
			}
		}catch(IOException e){
			e.printStackTrace();
		}
	}

	private static void prepareTrainMat(){
		prepareMat("stemmedTrain.txt", "finalTrain.txt");
	}

	private static void prepareValMat(){
		prepareMat("stemmedValidation.txt", "finalValidation.txt");
	}

	private static void prepareTestMat(){
		prepareMat("stemmedTest.txt", "finalTest.txt");
	}

	private static void prepareMat(String input, String output) {
		try{
			BufferedReader reader = new BufferedReader(new FileReader(input));
			String line = null;
			PrintWriter writer = new PrintWriter(output, "UTF-8");
			for(String s: dict)
				writer.print(s+"\t");
			writer.println();
			while ((line = reader.readLine()) != null) {
				SubReview sr = new SubReview();
				String[] arr = line.split(" ");
				for (int i = 0; i < arr.length; i++) {
					String s = arr[i].replaceAll("\\s+","");
					//					System.out.println(s);
					if(sr.wordcounts.containsKey(s)){
						sr.wordcounts.put(s, sr.wordcounts.get(s)+1);
					}
					else sr.wordcounts.put(s, 1);
				}
				for(String s: dict){
					if(sr.wordcounts.containsKey(s))
						writer.print(sr.wordcounts.get(s)+"\t");
					else
						writer.print("0\t");
				}
				writer.println();
			}
			writer.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	private static void populateReviews(){
		try{
			BufferedReader reader = new BufferedReader(new FileReader("yelp_validation.txt"));//yelp_training,yelp_testing
			//remember to change name of output files
			PrintWriter writer = new PrintWriter("onlyReviewsValidation.txt", "UTF-8");
			PrintWriter writer2 = new PrintWriter("validationLabels.txt", "UTF-8");
			String line = null;
			while ((line = reader.readLine()) != null) {
				Gson gson = new GsonBuilder().create();
				Review p = gson.fromJson(line, Review.class);
				String[] arr = p.text.split(" |\\.|/|\\?|!|,|\\)|\\(|:|\"|;|&|'");
				for (int i = 0; i < arr.length; i++) {
					String s = arr[i].replaceAll("\\s+","");
					boolean flag = true;
					for(int j=0;j<stopwords.length;j++) {
						if(s.equals(stopwords[j])) {
							flag = false;
						}
					}
					if(flag) {
						writer.print(s+" ");
					}
				}
				writer.println();
				writer2.println(p.stars);
			}
			writer.close();
			writer2.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	static class SubReview {
		HashMap<String, Integer> wordcounts;
		int stars;

		SubReview(){
			wordcounts = new HashMap<String, Integer>();
			stars = 0;
		}
	}

	class Review {
		String user_id;
		String review_id;
		int stars;
		String date;
		String text;
		String type;
		String business_id;

		public String toString() {
			return "Stars: " + review_id;
			//					+ " - " + text;
		}
	}
}
