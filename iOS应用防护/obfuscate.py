#!/usr/bin/env python
# -*- coding: utf-8 -*-
# 本脚本用于对源代码中的字符串进行加密
# 1. 在源代码中插入解密函数decryptConstString
# 2. 插入宏，替换所有的NSSTRING(...)和CSTRING(...)为decryptConstString(encrypted_string)
# 3. 替换所有字符串常量为加密的char数组，形式((char[]){1, 2, 3, 0})

import sys
import re
import os

# 插入宏和解密函数，解密方法：每个字节与0xAA异或
insert_code = '''#define STRING_OBFUSCATE

static char* decryptConstString(char* string) __attribute__((always_inline));

#define NSSTRING(string) [NSString stringWithUTF8String:decryptConstString(string)]
#define CSTRING(string) decryptConstString(string)

static char* decryptConstString(char* string)
{
    char* origin_string = string;
    while(*string) {
        *string ^= 0xAA;
        string++;
    }
    return origin_string;
}

#ifndef STRING_OBFUSCATE'''

# 替换字符串为((char[]){1, 2, 3, 0})的形式，同时让每个字节与0xAA异或进行加密
def replace(match):
    # print match.group()
    string = match.group(2) + '\x00'

    replaced_string = '((char []) {' + ', '.join(["%i" % ((ord(c) ^ 0xAA) if c != '\0' else 0) for c in list(string)]) + '})'
    # print replaced_string
    return match.group(1) + replaced_string + match.group(3)

# 修改源代码，加入字符串加密的函数
def obfuscate(file):
    with open(file, 'r') as f:
        code = f.read()
        f.close()
        code = re.sub(r'(NSSTRING\(|CSTRING\()"(.*?)"(\))', replace, code)
        code = code.replace('#ifndef STRING_OBFUSCATE', insert_code)
        # print code
        with open(file, 'w') as f:
            f.write(code)
            f.close()

if __name__ == '__main__':
    if len(sys.argv) == 2 and os.path.exists(sys.argv[1]):
        obfuscate(sys.argv[1])
    else:
        sys.exit()