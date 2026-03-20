package dev.studentpp1.mywebapp.controller;

import dev.studentpp1.mywebapp.dto.CreateItemDto;
import dev.studentpp1.mywebapp.dto.ItemResponseDto;
import dev.studentpp1.mywebapp.entity.Item;
import dev.studentpp1.mywebapp.service.ItemService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/items")
@RequiredArgsConstructor
public class ItemController {
    private final ItemService itemService;

    @GetMapping
    public ResponseEntity<List<ItemResponseDto>> getItems() {
        return ResponseEntity.ok(itemService.getItemList());
    }

    @PostMapping
    public ResponseEntity<Void> createItem(@RequestBody CreateItemDto newItem) {
        itemService.createNewItem(newItem);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Item> getItem(@PathVariable("id") Long id) {
        return ResponseEntity.ok(itemService.getItemById(id));
    }
}
