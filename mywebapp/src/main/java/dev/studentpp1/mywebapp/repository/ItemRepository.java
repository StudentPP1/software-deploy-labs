package dev.studentpp1.mywebapp.repository;

import dev.studentpp1.mywebapp.entity.Item;
import org.springframework.data.repository.ListCrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ItemRepository extends ListCrudRepository<Item, Long> {

}
