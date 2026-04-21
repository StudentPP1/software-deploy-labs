package dev.studentpp1.mywebapp.controller;

import dev.studentpp1.mywebapp.dto.CreateItemDto;
import dev.studentpp1.mywebapp.dto.ItemResponseDto;
import dev.studentpp1.mywebapp.entity.Item;
import dev.studentpp1.mywebapp.service.ItemService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/items")
@RequiredArgsConstructor
public class ItemController {
    private final ItemService itemService;

    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<List<ItemResponseDto>> getItemsJson() {
        return ResponseEntity.ok(itemService.getItemList());
    }

    @GetMapping(produces = MediaType.TEXT_HTML_VALUE)
    public String getItemsHtml() {
        List<ItemResponseDto> items = itemService.getItemList();
        StringBuilder html = new StringBuilder();
        html.append("<!DOCTYPE html><html><head><title>Inventory</title></head><body>");
        html.append("<table border='1'>");
        html.append("<tr><th>Id</th><th>Name</th></tr>");
        for (ItemResponseDto item : items) {
            html.append("<tr>")
                    .append("<td>").append(item.id()).append("</td>")
                    .append("<td>").append(item.name()).append("</td>")
                    .append("</tr>");
        }
        html.append("</table></body></html>");
        return html.toString();
    }

    @PostMapping(produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<Item> createItem(@RequestBody CreateItemDto newItem) {
        return ResponseEntity.ok(itemService.createNewItem(newItem));
    }

    @GetMapping(path = "/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Item> getItemJson(@PathVariable("id") Long id) {
        return ResponseEntity.ok(itemService.getItemById(id));
    }

    @GetMapping(path = "/{id}", produces = MediaType.TEXT_HTML_VALUE)
    public String getItemHtml(@PathVariable("id") Long id) {
        Item item = itemService.getItemById(id);
        StringBuilder html = new StringBuilder();
        html.append("<!DOCTYPE html><html><head><title>Inventory</title></head><body>");
        html.append("<h2>Item details</h2>");
        html.append("<h3>").append(item.getId()).append("</h3>");
        html.append("<h3>").append(item.getName()).append("</h3>");
        html.append("<h3>").append(item.getQuantity()).append("</h3>");
        html.append("<h3>").append(item.getCreatedAt()).append("</h3>");
        html.append("</body></html>");
        return html.toString();
    }
}
