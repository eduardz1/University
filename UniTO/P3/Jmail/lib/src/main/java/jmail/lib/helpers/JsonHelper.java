package jmail.lib.helpers;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;

public class JsonHelper {
    private static final ObjectMapper mapper = getMapper();

    public static ObjectMapper getMapper() {
        var map = new ObjectMapper();
        map.disable(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES);
        return new ObjectMapper();
    }

    public static <T> T fromJson(String json, Class<T> clazz) throws JsonProcessingException {
        return mapper.readValue(json, clazz);
    }

    public static <T> String toJson(T value) throws JsonProcessingException {
        return mapper.writeValueAsString(value);
    }
}
