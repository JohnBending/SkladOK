package com.ken.wms.common.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;


@Controller
@RequestMapping("/commons/fileSource")
public class FileSourceHandler {

    @RequestMapping(value = "download/{fileName:.+}", method = RequestMethod.GET)
    public void fileDownload(@PathVariable("fileName") String fileName, HttpServletRequest request,
                             HttpServletResponse response) throws IOException {

        if (fileName == null)
            return;

        ServletContext context = request.getServletContext();
        String directory = context.getRealPath("/WEB-INF/download");
        Path file = Paths.get(directory, fileName);
        if (Files.exists(file)) {
            response.addHeader("Content-Disposition", "attachment;filename=" + file.getFileName());
            Files.copy(file, response.getOutputStream());
            response.getOutputStream().flush();
        }
    }
}
