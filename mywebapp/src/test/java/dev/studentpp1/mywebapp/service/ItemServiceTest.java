package dev.studentpp1.mywebapp.service;

import dev.studentpp1.mywebapp.dto.CreateItemDto;
import dev.studentpp1.mywebapp.dto.ItemResponseDto;
import dev.studentpp1.mywebapp.entity.Item;
import dev.studentpp1.mywebapp.repository.ItemRepository;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ItemServiceTest {

    @Mock
    private ItemRepository itemRepository;

    @InjectMocks
    private ItemService itemService;

    private static final List<Item> items = new ArrayList<>();
    private static final List<ItemResponseDto> dtos = new ArrayList<>();

    @BeforeAll
    static void setUp() {
        items.add(new Item(1L, "test1", 10, LocalDateTime.now()));
        items.add(new Item(2L, "test2", 20, LocalDateTime.now().plusMinutes(1)));
        dtos.add(new ItemResponseDto(1L, "test1"));
        dtos.add(new ItemResponseDto(2L, "test2"));
    }

    @Test
    void getItemList() {
        when(itemRepository.findAll()).thenReturn(items);
        List<ItemResponseDto> response = itemService.getItemList();
        verify(itemRepository, times(1)).findAll();
        Assertions.assertEquals(dtos, response);
    }

    @Test
    void createNewItem() {
        CreateItemDto createItemDto = new CreateItemDto("test1", 10);
        Item item = items.getFirst();
        when(itemRepository.save(any())).thenReturn(item);
        Item response = itemService.createNewItem(createItemDto);
        verify(itemRepository, times(1)).save(any());
        Assertions.assertEquals(item, response);
    }

    @Test
    void getItemById() {
        Item item = items.getFirst();
        Long id = item.getId();
        when(itemRepository.findById(id)).thenReturn(Optional.of(item));
        Item response = itemService.getItemById(id);
        verify(itemRepository, times(1)).findById(id);
        Assertions.assertEquals(item, response);
    }
}