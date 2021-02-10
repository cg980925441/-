package com.zanpo.it;

import org.junit.Test;

import java.io.FileNotFoundException;
import java.io.IOException;

public class TestDemo {

    @Test
    public void testMemoryReplace() throws IOException {
        new IODemo().replaceFileContent("test.iml","orderEntry","test");
    }
}
