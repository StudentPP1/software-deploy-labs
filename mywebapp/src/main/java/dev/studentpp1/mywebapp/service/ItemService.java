package dev.studentpp1.mywebapp.service;

import dev.studentpp1.mywebapp.dto.CreateItemDto;
import dev.studentpp1.mywebapp.dto.ItemResponseDto;
import dev.studentpp1.mywebapp.entity.Item;
import dev.studentpp1.mywebapp.repository.ItemRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ItemService {
    private final ItemRepository itemRepository;

    public List<ItemResponseDto> getItemList() {
        return itemRepository.findAll().stream().map(this::mapToDto).toList();
    }

    public Item createNewItem(CreateItemDto newItem) {
        return itemRepository.save(Item.builder()
                .name(newItem.name())
                .quantity(newItem.quantity())
                .build());
    }

    public Item getItemById(Long id) {
        return itemRepository
                .findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Item with " + id + " doesn't exist"));
    }

    private ItemResponseDto mapToDto(Item item) {
        return new ItemResponseDto(item.getId(), item.getName());
    }
}
