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

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ItemServiceTest {

    @Mock
    private ItemRepository itemRepository;

    @InjectMocks
    private ItemService itemService;

    private static final List<Item> ITEMS = new ArrayList<>();
    private static final List<ItemResponseDto> DTOS = new ArrayList<>();

    @BeforeAll
    static void setUp() {
        ITEMS.add(new Item(1L, "test1", 10, LocalDateTime.now()));
        ITEMS.add(new Item(2L, "test2", 20, LocalDateTime.now().plusMinutes(1)));
        DTOS.add(new ItemResponseDto(1L, "test1"));
        DTOS.add(new ItemResponseDto(2L, "test2"));
    }

    @Test
    void getItemList() {
        when(itemRepository.findAll()).thenReturn(ITEMS);
        List<ItemResponseDto> response = itemService.getItemList();
        verify(itemRepository, times(1)).findAll();
        Assertions.assertEquals(DTOS, response);
    }

    @Test
    void createNewItem() {
        CreateItemDto createItemDto = new CreateItemDto("test1", 10);
        Item item = ITEMS.getFirst();
        when(itemRepository.save(any())).thenReturn(item);
        Item response = itemService.createNewItem(createItemDto);
        verify(itemRepository, times(1)).save(any());
        Assertions.assertEquals(item, response);
    }

    @Test
    void getItemById() {
        Item item = ITEMS.getFirst();
        Long id = item.getId();
        when(itemRepository.findById(id)).thenReturn(Optional.of(item));
        Item response = itemService.getItemById(id);
        verify(itemRepository, times(1)).findById(id);
        Assertions.assertEquals(item, response);
    }
}
