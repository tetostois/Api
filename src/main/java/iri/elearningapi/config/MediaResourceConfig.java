package iri.elearningapi.config;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import javax.annotation.PostConstruct;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class MediaResourceConfig implements WebMvcConfigurer {

    private static final Logger LOGGER = LoggerFactory.getLogger(MediaResourceConfig.class);

    private final String videoDirectoryProperty;

    public MediaResourceConfig(@Value("${app.media.video-directory:videos}") String videoDirectoryProperty) {
        this.videoDirectoryProperty = videoDirectoryProperty;
    }

    private Path resolveVideoDirectory() {
        String directory = StringUtils.hasText(videoDirectoryProperty) ? videoDirectoryProperty : "videos";
        return Paths.get(directory).toAbsolutePath().normalize();
    }

    @PostConstruct
    public void logVideoDirectory() {
        Path directory = resolveVideoDirectory();
        if (Files.exists(directory)) {
            LOGGER.info("Exposition des vidéos depuis le répertoire: {}", directory);
        } else {
            LOGGER.warn("Le répertoire des vidéos n'existe pas encore: {}. Veuillez le créer ou ajuster la propriété 'app.media.video-directory'.", directory);
        }
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        Path directory = resolveVideoDirectory();
        String resourceLocation = directory.toUri().toString();
        registry.addResourceHandler("/videos/**")
                .addResourceLocations(resourceLocation)
                .setCachePeriod(3600);
    }
}

