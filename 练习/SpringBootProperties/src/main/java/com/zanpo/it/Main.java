package com.zanpo.it;

import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.context.annotation.Configuration;

@Configuration
@SpringBootApplication
public class Main {
    public static void main(String[] args) {
        //1
//        SpringApplication.run(Main.class,args);

        //2
//        SpringApplication sa = new SpringApplication();
//        sa.run(Main.class);

        //3
        new SpringApplicationBuilder().sources(Main.class).run(args);
    }
}
