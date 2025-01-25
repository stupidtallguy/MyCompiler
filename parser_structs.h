#ifndef PARSER_STRUCTS_H
#define PARSER_STRUCTS_H

typedef struct {
    char* code;  // Holds generated three-address code
    char* place; // Temporary variable or constant
} ExprInfo;

#endif // PARSER_STRUCTS_H
