package application;	
import java.sql.SQLException;

import controller.Controller;
import dao_dto.DAO;
import javafx.application.Application;
import javafx.stage.Stage;
import model.Model;
import view.View;
import javafx.scene.Scene;
import javafx.scene.layout.BorderPane;


public class Main extends Application {
	@Override
	public void start(Stage primaryStage) {
		try {
			BorderPane root = new BorderPane();
			Scene scene = new Scene(root,400,400);
			scene.getStylesheets().add(getClass().getResource("application.css").toExternalForm());
			primaryStage.setScene(scene);
			primaryStage.show();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public static void main(String[] args) throws SQLException {
		DAO dao = new DAO();
		Model m1 = new Model();
		View v1 = new View();
		Controller c1 = new Controller(v1, m1);
		m1.setnomeModel();
		m1.stampanome();
		launch(args);
	}
}
