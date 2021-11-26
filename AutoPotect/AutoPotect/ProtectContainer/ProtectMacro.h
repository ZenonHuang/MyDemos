//
//  ProtectMacro.h
//  AutoPotect
//
//  Created by zz go on 2021/7/20.
//

#ifndef HZFetchPropertyName
#define HZFetchPropertyName(VAL) (@""#VAL)
#endif

#ifndef HZFetchClass
#define HZFetchClass(VAL) ([VAL class])
#endif

#ifndef HZIsValid
#define HZIsValid(VAL) (VAL)
#endif

#ifndef HZIsKindOfClass
#define HZIsKindOfClass(VAL, CLASS) ([VAL isKindOfClass:[CLASS class]])
#endif

#ifndef HZCheckInvalidAndKindOfClass

    #ifdef DEBUG
        #define HZCheckInvalidAndKindOfClass(VAL, CLASS)                                                                                                                    \
        (                                                                                                                                                                   \
        (                                                                                                                                                                   \
            (!HZIsValid(VAL)) ?                                                                                                                                             \
            ({NSAssert(NO, @"NSAssert => %s Line %d\nInvalid value of \"%@\" ", __PRETTY_FUNCTION__, __LINE__, HZFetchPropertyName(VAL));YES;})                             \
            : NO                                                                                                                                                            \
        )                                                                                                                                                                   \
        ||                                                                                                                                                                  \
        (                                                                                                                                                                   \
            (!HZIsKindOfClass((VAL), CLASS)) ?                                                                                                                                \
            ({NSAssert(NO, @"NSAssert => %s Line %d\nexpected class \"%@\" but class \"%@\" given ", __PRETTY_FUNCTION__, __LINE__, [CLASS class], HZFetchClass(VAL));YES;})  \
            : NO                                                                                                                                                            \
        )                                                                                                                                                                   \
        )
    #else
        #define HZCheckInvalidAndKindOfClass(VAL, CLASS)                                                                                                                      \
        (                                                                                                                                                                   \
        (                                                                                                                                                                   \
            (!HZIsValid(VAL)) ?                                                                                                                                            \
            ({                                                                                                                                                              \
                NSLog(@"%s Line %d\nInvalid value of \"%@\" ", __PRETTY_FUNCTION__, __LINE__, HZFetchPropertyName(VAL));                                                 \
                YES;                                                                                                                                                        \
            })                                                                                                                                                              \
            : NO                                                                                                                                                            \
        )                                                                                                                                                                   \
        ||                                                                                                                                                                  \
        (                                                                                                                                                                   \
            (!HZIsKindOfClass((VAL), CLASS)) ?                                                                                                                                \
            ({                                                                                                                                                              \
                NSLog(@"%s Line %d\nexpected class \"%@\" but class \"%@\" given ", __PRETTY_FUNCTION__, __LINE__, [CLASS class], HZFetchClass(VAL));                    \
                YES;                                                                                                                                                        \
            })                                                                                                                                                              \
            : NO                                                                                                                                                            \
        )                                                                                                                                                                   \
        )
    #endif

#endif
