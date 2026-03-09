package com.example.bookmanager.config;

import com.example.bookmanager.model.Role;
import com.example.bookmanager.repository.RoleRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class DataInitializer {

    /**
     * Chỉ tạo 2 role mặc định (ROLE_USER, ROLE_ADMIN) nếu chưa tồn tại.
     * Việc tạo user & gán role được thực hiện trực tiếp trong database.
     * Mật khẩu cần được mã hoá BCrypt trước khi insert
     * (dùng https://bcrypt-generator.com/ để tạo hash).
     */
    @Bean
    CommandLineRunner initRoles(RoleRepository roleRepo) {
        return args -> {
            if (roleRepo.findByName("ROLE_USER").isEmpty()) {
                roleRepo.save(new Role("ROLE_USER"));
            }
            if (roleRepo.findByName("ROLE_ADMIN").isEmpty()) {
                roleRepo.save(new Role("ROLE_ADMIN"));
            }
            System.out.println("=== Roles initialized (ROLE_USER, ROLE_ADMIN) ===");
            System.out.println(">>> Create users in DB, hash password at https://bcrypt-generator.com/");
        };
    }
}
