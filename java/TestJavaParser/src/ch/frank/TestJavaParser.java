package ch.frank;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.List;
import java.util.stream.Collectors;

import com.github.javaparser.JavaParser;
import com.github.javaparser.ast.CompilationUnit;
import com.github.javaparser.ast.body.ClassOrInterfaceDeclaration;

public class TestJavaParser {

	public static void main(String[] args) throws FileNotFoundException {
		String filename = args[0];
		CompilationUnit compilationUnit = JavaParser.parse(new File(filename));
		List<ClassOrInterfaceDeclaration> declarations = 
				compilationUnit.findAll(ClassOrInterfaceDeclaration.class)
			.stream()
			.collect(Collectors.toList());
		System.out.println(declarations.get(0).getChildNodes());
		System.out.println(declarations);
	}

}
