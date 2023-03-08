package com.assignment.moviecharacters.Config;

import org.apache.commons.dbcp2.BasicDataSource;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

import java.net.URI;
import java.net.URISyntaxException;

@Configuration
@Profile("production")
public class DataSourceConfig {
    @Value("#{systemEnvironment['DATABASE_URL']}")
    String databaseUrl;

    @Bean
    public BasicDataSource dataSource() throws URISyntaxException {
        BasicDataSource source = new BasicDataSource();
        source.setUrl(databaseUrl);

        return source;
    }
}
