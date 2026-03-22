package dev.studentpp1.mywebapp.controller;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class RootController {

    @GetMapping(value = "/", produces = MediaType.TEXT_HTML_VALUE)
    public String getEndpoints() {
        StringBuilder html = new StringBuilder();
        html.append("<!DOCTYPE html>\n");
        html.append("<html>\n");
        html.append("<head><title>Simple Inventory API</title></head>\n");
        html.append("<body>\n");
        html.append("<h1>Simple Inventory API</h1>\n");
        html.append("<p>Endpoints:</p>\n");
        html.append("<ul>\n");
        html.append("<li><strong>GET /items</strong> - list of items (id, name)</li>\n");
        html.append("<li><strong>POST /items</strong> - create a new item</li>\n");
        html.append("<li><strong>GET /items/id</strong> - item details</li>\n");
        html.append("</ul>\n");
        html.append("</body>\n");
        html.append("</html>");
        return html.toString();
    }
}
