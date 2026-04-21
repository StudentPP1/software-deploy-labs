package dev.studentpp1.mywebapp.controller;

import dev.studentpp1.mywebapp.dto.ItemResponseDto;
import dev.studentpp1.mywebapp.entity.Item;
import dev.studentpp1.mywebapp.repository.ItemRepository;
import dev.studentpp1.mywebapp.service.ItemService;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.hamcrest.Matchers.containsString;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(ItemController.class)
@Import(ItemService.class)
class ItemControllerTest {

    @MockitoBean
    private ItemRepository itemRepository;

    @Autowired
    private MockMvc mockMvc;

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
    void getItemsJson() throws Exception {
        when(itemRepository.findAll()).thenReturn(ITEMS);

        mockMvc.perform(get("/items").accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$[0].id").value(1L))
                .andExpect(jsonPath("$[0].name").value("test1"))
                .andExpect(jsonPath("$[1].id").value(2L))
                .andExpect(jsonPath("$[1].name").value("test2"));

        verify(itemRepository, times(1)).findAll();
    }

    @Test
    void getItemsHtml() throws Exception {
        when(itemRepository.findAll()).thenReturn(ITEMS);

        mockMvc.perform(get("/items").accept(MediaType.TEXT_HTML))
                .andExpect(status().isOk())
                .andExpect(content().contentTypeCompatibleWith(MediaType.TEXT_HTML))
                .andExpect(content().string(containsString("<table")))
                .andExpect(content().string(containsString("test1")))
                .andExpect(content().string(containsString("test2")));

        verify(itemRepository, times(1)).findAll();
    }

    @Test
    void createItem() throws Exception {
        Item item = ITEMS.getFirst();
        when(itemRepository.save(any())).thenReturn(item);

        mockMvc.perform(post("/items")
                        .accept(MediaType.APPLICATION_JSON)
                        .content("{\"name\": \"test1\", \"quantity\": 10}")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.id").value(1L))
                .andExpect(jsonPath("$.name").value("test1"))
                .andExpect(jsonPath("$.quantity").value(10));

        verify(itemRepository, times(1)).save(any());
    }

    @Test
    void getItemJson() throws Exception {
        Item item = ITEMS.getFirst();
        Long id = item.getId();
        when(itemRepository.findById(id)).thenReturn(Optional.of(item));

        mockMvc.perform(get("/items/{id}", id).accept(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.id").value(1L))
                .andExpect(jsonPath("$.name").value("test1"))
                .andExpect(jsonPath("$.quantity").value(10));

        verify(itemRepository, times(1)).findById(id);
    }

    @Test
    void getItemHtml() throws Exception {
        Item item = ITEMS.getFirst();
        Long id = item.getId();
        when(itemRepository.findById(id)).thenReturn(Optional.of(item));

        mockMvc.perform(get("/items/{id}", id).accept(MediaType.TEXT_HTML))
                .andExpect(status().isOk())
                .andExpect(content().contentTypeCompatibleWith(MediaType.TEXT_HTML))
                .andExpect(content().string(containsString("Item details")))
                .andExpect(content().string(containsString("test1")))
                .andExpect(content().string(containsString("10")));

        verify(itemRepository, times(1)).findById(id);
    }
}
