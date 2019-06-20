package com.ken.wms.security.util;


import org.springframework.stereotype.Component;

import java.awt.*;
import java.awt.geom.Line2D;
import java.awt.image.BufferedImage;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;


@Component
public class CheckCodeGenerator {

	private static char[] codeSequence = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O',
			'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' };

	private static int width = 80;//
	private static int height = 35;//
	private static int codeCount = 4;//
	private static int lineCounr = 20;
	private static Font font;//

	static {
		font = new Font("font", Font.BOLD|Font.ITALIC, 25);
	}


	public Map<String, Object> generlateCheckCode() {


		StringBuilder codeBuilder = new StringBuilder();

		Random random = new Random();


		BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_BGR);

		Graphics graphics = image.getGraphics();
		Graphics2D graphics2d = (Graphics2D) graphics;


		graphics.setColor(Color.white);
		graphics.fillRect(1, 1, width - 2, height - 2);
		graphics.setFont(font);
		
		graphics.setColor(Color.gray);

		for (int i = 1; i <= lineCounr; i++) {
			int x = random.nextInt(width - 1);
			int y = random.nextInt(height - 1);
			int x1 = random.nextInt(width - 1);
			int y1 = random.nextInt(height - 1);

			Line2D line2d = new Line2D.Double(x, y, x1, y1);

			graphics2d.draw(line2d);
		}


		for (int i = 0; i < codeCount; i++) {
			graphics.setColor(getRandColor());
			char c = codeSequence[random.nextInt(codeSequence.length - 1)];
			codeBuilder.append(c);
			graphics2d.drawString(c + "", 10 + 15 * i, 25);
		}

		Map<String, Object> checkCode = new HashMap<String,Object>();
		checkCode.put("checkCodeString", codeBuilder.toString());
		checkCode.put("checkCodeImage", image);
		
		return checkCode;
	}


	private Color getRandColor() {
		Random random = new Random();

		int r, g, b;
		r = random.nextInt(255);
		g = random.nextInt(255);
		b = random.nextInt(255);

		return new Color(r, g, b);
	}
}
