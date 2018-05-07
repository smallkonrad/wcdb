/*
 * Tencent is pleased to support the open source community by making
 * WCDB available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use
 * this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 *       https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "CRUDTestCase.h"

@interface TableTests_Convenient : CRUDTestCase

@end

@implementation TableTests_Convenient {
    WCTTable<TestCaseObject *> *_table;
}

- (void)setUp
{
    [super setUp];

    _table = [_database getTable:_tableName withClass:_cls];

    XCTAssertNotNil(_table);
}

- (void)tearDown
{
    _table = nil;

    [super tearDown];
}

#pragma mark - Get Object
- (void)test_get_object
{
    TestCaseObject *object = [_table getObject];
    XCTAssertTrue([object isEqualToObject:_preInserted[0]]);
}

- (void)test_get_object_where
{
    TestCaseObject *object = [_table getObjectWhere:_greaterThan0Condition];
    XCTAssertTrue([object isEqualToObject:_preInserted[1]]);
}

- (void)test_get_object_orderBy
{
    TestCaseObject *object = [_table getObjectOrderBy:_descendingOrder];
    XCTAssertTrue([object isEqualToObject:_preInserted.lastObject]);
}

- (void)test_get_object_offset
{
    TestCaseObject *object = [_table getObjectOffset:_offset1];
    XCTAssertTrue([object isEqualToObject:_preInserted[1]]);
}

- (void)test_get_object_where_orderBy
{
    TestCaseObject *object = [_table getObjectWhere:_removeBothEndCondition
                                            orderBy:_descendingOrder];
    XCTAssertTrue([object isEqualToObject:_preInserted[_preInserted.count - 2]]);
}

- (void)test_get_object_where_offset
{
    TestCaseObject *object = [_table getObjectWhere:_greaterThan0Condition
                                             offset:_offset1];
    XCTAssertTrue([object isEqualToObject:_preInserted[2]]);
}

- (void)test_get_object_orderBy_offset
{
    TestCaseObject *object = [_table getObjectOrderBy:_descendingOrder
                                               offset:_offset1];
    XCTAssertTrue([object isEqualToObject:_preInserted[_preInserted.count - 2]]);
}

- (void)test_get_object_where_orderBy_offset
{
    TestCaseObject *object = [_table getObjectWhere:_removeBothEndCondition
                                            orderBy:_descendingOrder
                                             offset:_offset1];
    XCTAssertTrue([object isEqualToObject:_preInserted[_preInserted.count - 3]]);
}

#pragma mark - Get Part Of Object
- (void)test_get_object_onProperties
{
    TestCaseObject *object = [_table getObjectOnProperties:{TestCaseObject.variable1, TestCaseObject.variable3}];
    XCTAssertTrue([object isEqualToObject:_preInserted[0] onProperties:TestCaseObjectPropertiesVariable1 | TestCaseObjectPropertiesVariable3]);
}

- (void)test_get_object_onProperties_where
{
    TestCaseObject *object = [_table getObjectOnProperties:{TestCaseObject.variable1, TestCaseObject.variable3} where:_greaterThan0Condition];
    XCTAssertTrue([object isEqualToObject:_preInserted[1] onProperties:TestCaseObjectPropertiesVariable1 | TestCaseObjectPropertiesVariable3]);
}

- (void)test_get_object_onProperties_orderBy
{
    TestCaseObject *object = [_table getObjectOnProperties:{TestCaseObject.variable1, TestCaseObject.variable3} orderBy:_descendingOrder];
    XCTAssertTrue([object isEqualToObject:_preInserted.lastObject onProperties:TestCaseObjectPropertiesVariable1 | TestCaseObjectPropertiesVariable3]);
}

- (void)test_get_object_onProperties_offset
{
    TestCaseObject *object = [_table getObjectOnProperties:{TestCaseObject.variable1, TestCaseObject.variable3} offset:_offset1];
    XCTAssertTrue([object isEqualToObject:_preInserted[1] onProperties:TestCaseObjectPropertiesVariable1 | TestCaseObjectPropertiesVariable3]);
}

- (void)test_get_object_onProperties_where_orderBy
{
    TestCaseObject *object = [_table getObjectOnProperties:{TestCaseObject.variable1, TestCaseObject.variable3} where:_removeBothEndCondition orderBy:_descendingOrder];
    XCTAssertTrue([object isEqualToObject:_preInserted[_preInserted.count - 2] onProperties:TestCaseObjectPropertiesVariable1 | TestCaseObjectPropertiesVariable3]);
}

- (void)test_get_object_onProperties_where_offset
{
    TestCaseObject *object = [_table getObjectOnProperties:{TestCaseObject.variable1, TestCaseObject.variable3} where:_greaterThan0Condition offset:_offset1];
    XCTAssertTrue([object isEqualToObject:_preInserted[2] onProperties:TestCaseObjectPropertiesVariable1 | TestCaseObjectPropertiesVariable3]);
}

- (void)test_get_object_onProperties_orderBy_offset
{
    TestCaseObject *object = [_table getObjectOnProperties:{TestCaseObject.variable1, TestCaseObject.variable3} orderBy:_descendingOrder offset:_offset1];
    XCTAssertTrue([object isEqualToObject:_preInserted[_preInserted.count - 2] onProperties:TestCaseObjectPropertiesVariable1 | TestCaseObjectPropertiesVariable3]);
}

- (void)test_get_object_onProperties_where_orderBy_offset
{
    TestCaseObject *object = [_table getObjectOnProperties:{TestCaseObject.variable1, TestCaseObject.variable3}
                                                     where:_removeBothEndCondition
                                                   orderBy:_descendingOrder
                                                    offset:_offset1];
    XCTAssertTrue([object isEqualToObject:_preInserted[_preInserted.count - 3] onProperties:TestCaseObjectPropertiesVariable1 | TestCaseObjectPropertiesVariable3]);
}

#pragma mark - Get One Row
- (void)test_get_row_on_results
{
    WCTOneRow *row = [_table getRowOnResults:{TestCaseObject.variable1, TestCaseObject.variable3}];
    XCTAssertEqual(row.count, 2);
    XCTAssertEqual(row[0].numberValue.intValue, _preInserted[0].variable1);
    XCTAssertEqual(row[1].numberValue.doubleValue, _preInserted[0].variable3);
}

- (void)test_get_row_on_results_where
{
    WCTOneRow *row = [_table getRowOnResults:{TestCaseObject.variable1, TestCaseObject.variable3} where:_greaterThan0Condition];
    XCTAssertEqual(row.count, 2);
    XCTAssertEqual(row[0].numberValue.intValue, _preInserted[1].variable1);
    XCTAssertEqual(row[1].numberValue.doubleValue, _preInserted[1].variable3);
}

- (void)test_get_row_on_results_orderBy
{
    WCTOneRow *row = [_table getRowOnResults:{TestCaseObject.variable1, TestCaseObject.variable3} orderBy:_descendingOrder];
    XCTAssertEqual(row.count, 2);
    XCTAssertEqual(row[0].numberValue.intValue, _preInserted.lastObject.variable1);
    XCTAssertEqual(row[1].numberValue.doubleValue, _preInserted.lastObject.variable3);
}

- (void)test_get_row_on_results_offset
{
    WCTOneRow *row = [_table getRowOnResults:{TestCaseObject.variable1, TestCaseObject.variable3} offset:_offset1];
    XCTAssertEqual(row.count, 2);
    XCTAssertEqual(row[0].numberValue.intValue, _preInserted[1].variable1);
    XCTAssertEqual(row[1].numberValue.doubleValue, _preInserted[1].variable3);
}

- (void)test_get_row_on_results_where_orderBy
{
    WCTOneRow *row = [_table getRowOnResults:{TestCaseObject.variable1, TestCaseObject.variable3} where:_removeBothEndCondition orderBy:_descendingOrder];
    XCTAssertEqual(row.count, 2);
    XCTAssertEqual(row[0].numberValue.intValue, _preInserted[_preInserted.count - 2].variable1);
    XCTAssertEqual(row[1].numberValue.doubleValue, _preInserted[_preInserted.count - 2].variable3);
}

- (void)test_get_row_on_results_where_offset
{
    WCTOneRow *row = [_table getRowOnResults:{TestCaseObject.variable1, TestCaseObject.variable3}
                                       where:_greaterThan0Condition
                                      offset:_offset1];
    XCTAssertEqual(row.count, 2);
    XCTAssertEqual(row[0].numberValue.intValue, _preInserted[2].variable1);
    XCTAssertEqual(row[1].numberValue.doubleValue, _preInserted[2].variable3);
}

- (void)test_get_row_on_results_orderBy_offset
{
    WCTOneRow *row = [_table getRowOnResults:{TestCaseObject.variable1, TestCaseObject.variable3}
                                     orderBy:_descendingOrder
                                      offset:_offset1];
    XCTAssertEqual(row.count, 2);
    XCTAssertEqual(row[0].numberValue.intValue, _preInserted[_preInserted.count - 2].variable1);
    XCTAssertEqual(row[1].numberValue.doubleValue, _preInserted[_preInserted.count - 2].variable3);
}

- (void)test_get_row_on_results_where_orderBy_offset
{
    WCTOneRow *row = [_table getRowOnResults:{TestCaseObject.variable1, TestCaseObject.variable3}
                                       where:_removeBothEndCondition
                                     orderBy:_descendingOrder
                                      offset:_offset1];
    XCTAssertEqual(row.count, 2);
    XCTAssertEqual(row[0].numberValue.intValue, _preInserted[_preInserted.count - 3].variable1);
    XCTAssertEqual(row[1].numberValue.doubleValue, _preInserted[_preInserted.count - 3].variable3);
}

#pragma mark - Get One Column
- (void)test_get_column_onResult
{
    WCTOneColumn *column = [_table getColumnOnResult:TestCaseObject.variable1];
    XCTAssertTrue([column isEqualToObjects:_preInserted
                            withComparator:^BOOL(WCTValue *lhs, TestCaseObject *rhs) {
                              return lhs.numberValue.intValue == rhs.variable1;
                            }]);
}

- (void)test_get_column_onResult_where
{
    WCTOneColumn *column = [_table getColumnOnResult:TestCaseObject.variable1 where:_greaterThan0Condition];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray arrayWithArray:_preInserted];
    [result removeObjectAtIndex:0];
    XCTAssertTrue([column isEqualToObjects:result
                            withComparator:^BOOL(WCTValue *lhs, TestCaseObject *rhs) {
                              return lhs.numberValue.intValue == rhs.variable1;
                            }]);
}

- (void)test_get_column_onResult_orderBy
{
    WCTOneColumn *column = [_table getColumnOnResult:TestCaseObject.variable1 orderBy:_descendingOrder];
    NSArray<TestCaseObject *> *result = _preInserted.reversed;
    XCTAssertTrue([column isEqualToObjects:result
                            withComparator:^BOOL(WCTValue *lhs, TestCaseObject *rhs) {
                              return lhs.numberValue.intValue == rhs.variable1;
                            }]);
}

- (void)test_get_column_onResult_limit
{
    WCTOneColumn *column = [_table getColumnOnResult:TestCaseObject.variable1 limit:_limit1];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithObject:[_preInserted objectAtIndex:0]];
    XCTAssertTrue([column isEqualToObjects:result
                            withComparator:^BOOL(WCTValue *lhs, TestCaseObject *rhs) {
                              return lhs.numberValue.intValue == rhs.variable1;
                            }]);
}

- (void)test_get_column_onResult_where_orderBy
{
    WCTOneColumn *column = [_table getColumnOnResult:TestCaseObject.variable1
                                               where:_removeBothEndCondition
                                             orderBy:_descendingOrder];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithArray:_preInserted];
    [result removeObjectAtIndex:0];
    [result removeLastObject];
    result = result.reversed;
    XCTAssertTrue([column isEqualToObjects:result
                            withComparator:^BOOL(WCTValue *lhs, TestCaseObject *rhs) {
                              return lhs.numberValue.intValue == rhs.variable1;
                            }]);
}

- (void)test_get_column_onResult_where_limit
{
    WCTOneColumn *column = [_table getColumnOnResult:TestCaseObject.variable1
                                               where:_removeBothEndCondition
                                               limit:_limit1];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithObject:_preInserted[1]];
    XCTAssertTrue([column isEqualToObjects:result
                            withComparator:^BOOL(WCTValue *lhs, TestCaseObject *rhs) {
                              return lhs.numberValue.intValue == rhs.variable1;
                            }]);
}

- (void)test_get_column_onResult_orderBy_limit
{
    WCTOneColumn *column = [_table getColumnOnResult:TestCaseObject.variable1
                                             orderBy:_descendingOrder
                                               limit:_limit1];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithObject:_preInserted[_preInserted.count - 1]];
    XCTAssertTrue([column isEqualToObjects:result
                            withComparator:^BOOL(WCTValue *lhs, TestCaseObject *rhs) {
                              return lhs.numberValue.intValue == rhs.variable1;
                            }]);
}

- (void)test_get_column_onResult_limit_offset
{
    WCTOneColumn *column = [_table getColumnOnResult:TestCaseObject.variable1
                                               limit:_limit1
                                              offset:_offset1];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithObject:_preInserted[1]];
    XCTAssertTrue([column isEqualToObjects:result
                            withComparator:^BOOL(WCTValue *lhs, TestCaseObject *rhs) {
                              return lhs.numberValue.intValue == rhs.variable1;
                            }]);
}

- (void)test_get_column_onResult_where_orderBy_limit
{
    WCTOneColumn *column = [_table getColumnOnResult:TestCaseObject.variable1
                                             orderBy:_descendingOrder
                                               limit:_limit1];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithObject:_preInserted[_preInserted.count - 1]];
    XCTAssertTrue([column isEqualToObjects:result
                            withComparator:^BOOL(WCTValue *lhs, TestCaseObject *rhs) {
                              return lhs.numberValue.intValue == rhs.variable1;
                            }]);
}

- (void)test_get_column_onResult_where_limit_offset
{
    WCTOneColumn *column = [_table getColumnOnResult:TestCaseObject.variable1
                                               where:_removeBothEndCondition
                                               limit:_limit1
                                              offset:_offset1];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithArray:_preInserted];
    [result removeObjectAtIndex:0];
    [result removeLastObject];
    result = [NSMutableArray<TestCaseObject *> arrayWithObject:result[1]];
    XCTAssertTrue([column isEqualToObjects:result
                            withComparator:^BOOL(WCTValue *lhs, TestCaseObject *rhs) {
                              return lhs.numberValue.intValue == rhs.variable1;
                            }]);
}

- (void)test_get_column_onResult_orderBy_limit_offset
{
    WCTOneColumn *column = [_table getColumnOnResult:TestCaseObject.variable1
                                             orderBy:_descendingOrder
                                               limit:_limit1
                                              offset:_offset1];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithArray:_preInserted];
    result = result.reversed;
    result = [NSMutableArray<TestCaseObject *> arrayWithObject:result[1]];
    XCTAssertTrue([column isEqualToObjects:result
                            withComparator:^BOOL(WCTValue *lhs, TestCaseObject *rhs) {
                              return lhs.numberValue.intValue == rhs.variable1;
                            }]);
}

- (void)test_get_column_onResult_where_orderBy_limit_offset
{
    WCTOneColumn *column = [_table getColumnOnResult:TestCaseObject.variable1
                                               where:_removeBothEndCondition
                                             orderBy:_descendingOrder
                                               limit:_limit1
                                              offset:_offset1];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithArray:_preInserted];
    [result removeObjectAtIndex:0];
    [result removeLastObject];
    result = result.reversed;
    result = [NSMutableArray<TestCaseObject *> arrayWithObject:result[1]];
    XCTAssertTrue([column isEqualToObjects:result
                            withComparator:^BOOL(WCTValue *lhs, TestCaseObject *rhs) {
                              return lhs.numberValue.intValue == rhs.variable1;
                            }]);
}

#pragma mark - Get One Value
- (void)test_get_value_on_result
{
    WCTValue *value = [_table getValueOnResult:TestCaseObject.variable1];
    XCTAssertEqual(value.numberValue.intValue, _preInserted[0].variable1);
}

- (void)test_get_value_on_result_where
{
    WCTValue *value = [_table getValueOnResult:TestCaseObject.variable1 where:_greaterThan0Condition];
    XCTAssertEqual(value.numberValue.intValue, _preInserted[1].variable1);
}

- (void)test_get_value_on_result_orderBy
{
    WCTValue *value = [_table getValueOnResult:TestCaseObject.variable1 orderBy:_descendingOrder];
    XCTAssertEqual(value.numberValue.intValue, _preInserted.lastObject.variable1);
}

- (void)test_get_value_on_result_offset
{
    WCTValue *value = [_table getValueOnResult:TestCaseObject.variable1 offset:_offset1];
    XCTAssertEqual(value.numberValue.intValue, _preInserted[1].variable1);
}

- (void)test_get_value_on_result_where_orderBy
{
    WCTValue *value = [_table getValueOnResult:TestCaseObject.variable1
                                         where:_removeBothEndCondition
                                       orderBy:_descendingOrder];
    XCTAssertEqual(value.numberValue.intValue, _preInserted[_preInserted.count - 2].variable1);
}

- (void)test_get_value_on_result_where_offset
{
    WCTValue *value = [_table getValueOnResult:TestCaseObject.variable1
                                         where:_greaterThan0Condition
                                        offset:_offset1];
    XCTAssertEqual(value.numberValue.intValue, _preInserted[2].variable1);
}

- (void)test_get_value_on_result_orderBy_offset
{
    WCTValue *value = [_table getValueOnResult:TestCaseObject.variable1
                                       orderBy:_descendingOrder
                                        offset:_offset1];
    XCTAssertEqual(value.numberValue.intValue, _preInserted[_preInserted.count - 2].variable1);
}

- (void)test_get_value_on_result_where_orderBy_offset
{
    WCTValue *value = [_table getValueOnResult:TestCaseObject.variable1
                                         where:_removeBothEndCondition
                                       orderBy:_descendingOrder
                                        offset:_offset1];
    XCTAssertEqual(value.numberValue.intValue, _preInserted[_preInserted.count - 3].variable1);
}

#pragma mark - Get Objects
- (void)test_get_objects
{
    NSArray<TestCaseObject *> *objects = [_table getObjects];
    XCTAssertTrue([objects isEqualToTestCaseObjects:_preInserted]);
}

- (void)test_get_objects_where
{
    NSArray<TestCaseObject *> *objects = [_table getObjectsWhere:_greaterThan0Condition];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray arrayWithArray:_preInserted];
    [result removeObjectAtIndex:0];
    XCTAssertTrue([objects isEqualToTestCaseObjects:result]);
}

- (void)test_get_objects_orderBy
{
    NSArray<TestCaseObject *> *objects = [_table getObjectsOrderBy:_descendingOrder];
    NSArray<TestCaseObject *> *result = _preInserted.reversed;
    XCTAssertTrue([objects isEqualToTestCaseObjects:result]);
}

- (void)test_get_objects_limit
{
    NSArray<TestCaseObject *> *objects = [_table getObjectsLimit:_limit1];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithObject:[_preInserted objectAtIndex:0]];
    XCTAssertTrue([objects isEqualToTestCaseObjects:result]);
}

- (void)test_get_objects_where_orderBy
{
    NSArray<TestCaseObject *> *objects = [_table getObjectsWhere:_removeBothEndCondition
                                                         orderBy:_descendingOrder];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithArray:_preInserted];
    [result removeObjectAtIndex:0];
    [result removeLastObject];
    result = result.reversed;
    XCTAssertTrue([objects isEqualToTestCaseObjects:result]);
}

- (void)test_get_objects_where_limit
{
    NSArray<TestCaseObject *> *objects = [_table getObjectsWhere:_removeBothEndCondition
                                                           limit:_limit1];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithObject:_preInserted[1]];
    XCTAssertTrue([objects isEqualToTestCaseObjects:result]);
}

- (void)test_get_objects_orderBy_limit
{
    NSArray<TestCaseObject *> *objects = [_table getObjectsOrderBy:_descendingOrder
                                                             limit:_limit1];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithObject:_preInserted[_preInserted.count - 1]];
    XCTAssertTrue([objects isEqualToTestCaseObjects:result]);
}

- (void)test_get_objects_limit_offset
{
    NSArray<TestCaseObject *> *objects = [_table getObjectsLimit:_limit1
                                                          offset:_offset1];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithObject:_preInserted[1]];
    XCTAssertTrue([objects isEqualToTestCaseObjects:result]);
}

- (void)test_get_objects_where_orderBy_limit
{
    NSArray<TestCaseObject *> *objects = [_table getObjectsOrderBy:_descendingOrder
                                                             limit:_limit1];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithObject:_preInserted[_preInserted.count - 1]];
    XCTAssertTrue([objects isEqualToTestCaseObjects:result]);
}

- (void)test_get_objects_where_limit_offset
{
    NSArray<TestCaseObject *> *objects = [_table getObjectsWhere:_removeBothEndCondition
                                                           limit:_limit1
                                                          offset:_offset1];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithArray:_preInserted];
    [result removeObjectAtIndex:0];
    [result removeLastObject];
    result = [NSMutableArray<TestCaseObject *> arrayWithObject:result[1]];
    XCTAssertTrue([objects isEqualToTestCaseObjects:result]);
}

- (void)test_get_objects_orderBy_limit_offset
{
    NSArray<TestCaseObject *> *objects = [_table getObjectsOrderBy:_descendingOrder
                                                             limit:_limit1
                                                            offset:_offset1];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithArray:_preInserted];
    result = result.reversed;
    result = [NSMutableArray<TestCaseObject *> arrayWithObject:result[1]];
    XCTAssertTrue([objects isEqualToTestCaseObjects:result]);
}

- (void)test_get_objects_where_orderBy_limit_offset
{
    NSArray<TestCaseObject *> *objects = [_table getObjectsWhere:_removeBothEndCondition
                                                         orderBy:_descendingOrder
                                                           limit:_limit1
                                                          offset:_offset1];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithArray:_preInserted];
    [result removeObjectAtIndex:0];
    [result removeLastObject];
    result = result.reversed;
    result = [NSMutableArray<TestCaseObject *> arrayWithObject:result[1]];
    XCTAssertTrue([objects isEqualToTestCaseObjects:result]);
}

#pragma mark - Get Part Of Objects
- (void)test_get_objects_onProperties
{
    NSArray<TestCaseObject *> *objects = [_table getObjectsOnProperties:{TestCaseObject.variable1, TestCaseObject.variable2}];
    XCTAssertTrue([objects isEqualToTestCaseObjects:_preInserted onProperties:TestCaseObjectPropertiesVariable1 | TestCaseObjectPropertiesVariable2]);
}

- (void)test_get_objects_onProperties_where
{
    NSArray<TestCaseObject *> *objects = [_table getObjectsOnProperties:{TestCaseObject.variable1, TestCaseObject.variable2} where:_greaterThan0Condition];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray arrayWithArray:_preInserted];
    [result removeObjectAtIndex:0];
    XCTAssertTrue([objects isEqualToTestCaseObjects:result onProperties:TestCaseObjectPropertiesVariable1 | TestCaseObjectPropertiesVariable2]);
}

- (void)test_get_objects_onProperties_orderBy
{
    NSArray<TestCaseObject *> *objects = [_table getObjectsOnProperties:{TestCaseObject.variable1, TestCaseObject.variable2} orderBy:_descendingOrder];
    NSArray<TestCaseObject *> *result = _preInserted.reversed;
    XCTAssertTrue([objects isEqualToTestCaseObjects:result onProperties:TestCaseObjectPropertiesVariable1 | TestCaseObjectPropertiesVariable2]);
}

- (void)test_get_objects_onProperties_limit
{
    NSArray<TestCaseObject *> *objects = [_table getObjectsOnProperties:{TestCaseObject.variable1, TestCaseObject.variable2} limit:_limit1];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithObject:[_preInserted objectAtIndex:0]];
    XCTAssertTrue([objects isEqualToTestCaseObjects:result onProperties:TestCaseObjectPropertiesVariable1 | TestCaseObjectPropertiesVariable2]);
}

- (void)test_get_objects_onProperties_where_orderBy
{
    NSArray<TestCaseObject *> *objects = [_table getObjectsOnProperties:{TestCaseObject.variable1, TestCaseObject.variable2}
                                                                  where:_removeBothEndCondition
                                                                orderBy:_descendingOrder];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithArray:_preInserted];
    [result removeObjectAtIndex:0];
    [result removeLastObject];
    result = result.reversed;
    XCTAssertTrue([objects isEqualToTestCaseObjects:result onProperties:TestCaseObjectPropertiesVariable1 | TestCaseObjectPropertiesVariable2]);
}

- (void)test_get_objects_onProperties_where_limit
{
    NSArray<TestCaseObject *> *objects = [_table getObjectsOnProperties:{TestCaseObject.variable1, TestCaseObject.variable2}
                                                                  where:_removeBothEndCondition
                                                                  limit:_limit1];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithObject:_preInserted[1]];
    XCTAssertTrue([objects isEqualToTestCaseObjects:result onProperties:TestCaseObjectPropertiesVariable1 | TestCaseObjectPropertiesVariable2]);
}

- (void)test_get_objects_onProperties_orderBy_limit
{
    NSArray<TestCaseObject *> *objects = [_table getObjectsOnProperties:{TestCaseObject.variable1, TestCaseObject.variable2}
                                                                orderBy:_descendingOrder
                                                                  limit:_limit1];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithObject:_preInserted[_preInserted.count - 1]];
    XCTAssertTrue([objects isEqualToTestCaseObjects:result onProperties:TestCaseObjectPropertiesVariable1 | TestCaseObjectPropertiesVariable2]);
}

- (void)test_get_objects_onProperties_limit_offset
{
    NSArray<TestCaseObject *> *objects = [_table getObjectsOnProperties:{TestCaseObject.variable1, TestCaseObject.variable2}
                                                                  limit:_limit1
                                                                 offset:_offset1];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithObject:_preInserted[1]];
    XCTAssertTrue([objects isEqualToTestCaseObjects:result onProperties:TestCaseObjectPropertiesVariable1 | TestCaseObjectPropertiesVariable2]);
}

- (void)test_get_objects_onProperties_where_orderBy_limit
{
    NSArray<TestCaseObject *> *objects = [_table getObjectsOnProperties:{TestCaseObject.variable1, TestCaseObject.variable2}
                                                                orderBy:_descendingOrder
                                                                  limit:_limit1];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithObject:_preInserted[_preInserted.count - 1]];
    XCTAssertTrue([objects isEqualToTestCaseObjects:result onProperties:TestCaseObjectPropertiesVariable1 | TestCaseObjectPropertiesVariable2]);
}

- (void)test_get_objects_onProperties_where_limit_offset
{
    NSArray<TestCaseObject *> *objects = [_table getObjectsOnProperties:{TestCaseObject.variable1, TestCaseObject.variable2}
                                                                  where:_removeBothEndCondition
                                                                  limit:_limit1
                                                                 offset:_offset1];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithArray:_preInserted];
    [result removeObjectAtIndex:0];
    [result removeLastObject];
    result = [NSMutableArray<TestCaseObject *> arrayWithObject:result[1]];
    XCTAssertTrue([objects isEqualToTestCaseObjects:result onProperties:TestCaseObjectPropertiesVariable1 | TestCaseObjectPropertiesVariable2]);
}

- (void)test_get_objects_onProperties_orderBy_limit_offset
{
    NSArray<TestCaseObject *> *objects = [_table getObjectsOnProperties:{TestCaseObject.variable1, TestCaseObject.variable2}
                                                                orderBy:_descendingOrder
                                                                  limit:_limit1
                                                                 offset:_offset1];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithArray:_preInserted];
    result = result.reversed;
    result = [NSMutableArray<TestCaseObject *> arrayWithObject:result[1]];
    XCTAssertTrue([objects isEqualToTestCaseObjects:result onProperties:TestCaseObjectPropertiesVariable1 | TestCaseObjectPropertiesVariable2]);
}

- (void)test_get_objects_onProperties_where_orderBy_limit_offset
{
    NSArray<TestCaseObject *> *objects = [_table getObjectsOnProperties:{TestCaseObject.variable1, TestCaseObject.variable2}
                                                                  where:_removeBothEndCondition
                                                                orderBy:_descendingOrder
                                                                  limit:_limit1
                                                                 offset:_offset1];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithArray:_preInserted];
    [result removeObjectAtIndex:0];
    [result removeLastObject];
    result = result.reversed;
    result = [NSMutableArray<TestCaseObject *> arrayWithObject:result[1]];
    XCTAssertTrue([objects isEqualToTestCaseObjects:result onProperties:TestCaseObjectPropertiesVariable1 | TestCaseObjectPropertiesVariable2]);
}

#pragma mark - Get Rows
- (void)test_get_rows_onResults
{
    WCTColumnsXRows *rows = [_table getRowsOnResults:{TestCaseObject.variable1, TestCaseObject.variable3}];
    XCTAssertTrue([rows isEqualToObjects:_preInserted
                          withComparator:^BOOL(WCTOneRow *lhs, TestCaseObject *rhs) {
                            if (lhs.count != 2) {
                                return NO;
                            }
                            return lhs[0].numberValue.intValue == rhs.variable1 && lhs[1].numberValue.doubleValue == rhs.variable3;
                          }]);
}

- (void)test_get_rows_onResults_where
{
    WCTColumnsXRows *rows = [_table getRowsOnResults:{TestCaseObject.variable1, TestCaseObject.variable3} where:_greaterThan0Condition];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray arrayWithArray:_preInserted];
    [result removeObjectAtIndex:0];
    XCTAssertTrue([rows isEqualToObjects:result
                          withComparator:^BOOL(WCTOneRow *lhs, TestCaseObject *rhs) {
                            if (lhs.count != 2) {
                                return NO;
                            }
                            return lhs[0].numberValue.intValue == rhs.variable1 && lhs[1].numberValue.doubleValue == rhs.variable3;
                          }]);
}

- (void)test_get_rows_onResults_orderBy
{
    WCTColumnsXRows *rows = [_table getRowsOnResults:{TestCaseObject.variable1, TestCaseObject.variable3} orderBy:_descendingOrder];
    NSArray<TestCaseObject *> *result = _preInserted.reversed;
    XCTAssertTrue([rows isEqualToObjects:result
                          withComparator:^BOOL(WCTOneRow *lhs, TestCaseObject *rhs) {
                            if (lhs.count != 2) {
                                return NO;
                            }
                            return lhs[0].numberValue.intValue == rhs.variable1 && lhs[1].numberValue.doubleValue == rhs.variable3;
                          }]);
}

- (void)test_get_rows_onResults_limit
{
    WCTColumnsXRows *rows = [_table getRowsOnResults:{TestCaseObject.variable1, TestCaseObject.variable3} limit:_limit1];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithObject:[_preInserted objectAtIndex:0]];
    XCTAssertTrue([rows isEqualToObjects:result
                          withComparator:^BOOL(WCTOneRow *lhs, TestCaseObject *rhs) {
                            if (lhs.count != 2) {
                                return NO;
                            }
                            return lhs[0].numberValue.intValue == rhs.variable1 && lhs[1].numberValue.doubleValue == rhs.variable3;
                          }]);
}

- (void)test_get_rows_onResults_where_orderBy
{
    WCTColumnsXRows *rows = [_table getRowsOnResults:{TestCaseObject.variable1, TestCaseObject.variable3}
                                               where:_removeBothEndCondition
                                             orderBy:_descendingOrder];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithArray:_preInserted];
    [result removeObjectAtIndex:0];
    [result removeLastObject];
    result = result.reversed;
    XCTAssertTrue([rows isEqualToObjects:result
                          withComparator:^BOOL(WCTOneRow *lhs, TestCaseObject *rhs) {
                            if (lhs.count != 2) {
                                return NO;
                            }
                            return lhs[0].numberValue.intValue == rhs.variable1 && lhs[1].numberValue.doubleValue == rhs.variable3;
                          }]);
}

- (void)test_get_rows_onResults_where_limit
{
    WCTColumnsXRows *rows = [_table getRowsOnResults:{TestCaseObject.variable1, TestCaseObject.variable3}
                                               where:_removeBothEndCondition
                                               limit:_limit1];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithObject:_preInserted[1]];
    XCTAssertTrue([rows isEqualToObjects:result
                          withComparator:^BOOL(WCTOneRow *lhs, TestCaseObject *rhs) {
                            if (lhs.count != 2) {
                                return NO;
                            }
                            return lhs[0].numberValue.intValue == rhs.variable1 && lhs[1].numberValue.doubleValue == rhs.variable3;
                          }]);
}

- (void)test_get_rows_onResults_orderBy_limit
{
    WCTColumnsXRows *rows = [_table getRowsOnResults:{TestCaseObject.variable1, TestCaseObject.variable3}
                                             orderBy:_descendingOrder
                                               limit:_limit1];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithObject:_preInserted[_preInserted.count - 1]];
    XCTAssertTrue([rows isEqualToObjects:result
                          withComparator:^BOOL(WCTOneRow *lhs, TestCaseObject *rhs) {
                            if (lhs.count != 2) {
                                return NO;
                            }
                            return lhs[0].numberValue.intValue == rhs.variable1 && lhs[1].numberValue.doubleValue == rhs.variable3;
                          }]);
}

- (void)test_get_rows_onResults_limit_offset
{
    WCTColumnsXRows *rows = [_table getRowsOnResults:{TestCaseObject.variable1, TestCaseObject.variable3}
                                               limit:_limit1
                                              offset:_offset1];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithObject:_preInserted[1]];
    XCTAssertTrue([rows isEqualToObjects:result
                          withComparator:^BOOL(WCTOneRow *lhs, TestCaseObject *rhs) {
                            if (lhs.count != 2) {
                                return NO;
                            }
                            return lhs[0].numberValue.intValue == rhs.variable1 && lhs[1].numberValue.doubleValue == rhs.variable3;
                          }]);
}

- (void)test_get_rows_onResults_where_orderBy_limit
{
    WCTColumnsXRows *rows = [_table getRowsOnResults:{TestCaseObject.variable1, TestCaseObject.variable3}
                                             orderBy:_descendingOrder
                                               limit:_limit1];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithObject:_preInserted[_preInserted.count - 1]];
    XCTAssertTrue([rows isEqualToObjects:result
                          withComparator:^BOOL(WCTOneRow *lhs, TestCaseObject *rhs) {
                            if (lhs.count != 2) {
                                return NO;
                            }
                            return lhs[0].numberValue.intValue == rhs.variable1 && lhs[1].numberValue.doubleValue == rhs.variable3;
                          }]);
}

- (void)test_get_rows_onResults_where_limit_offset
{
    WCTColumnsXRows *rows = [_table getRowsOnResults:{TestCaseObject.variable1, TestCaseObject.variable3}
                                               where:_removeBothEndCondition
                                               limit:_limit1
                                              offset:_offset1];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithArray:_preInserted];
    [result removeObjectAtIndex:0];
    [result removeLastObject];
    result = [NSMutableArray<TestCaseObject *> arrayWithObject:result[1]];
    XCTAssertTrue([rows isEqualToObjects:result
                          withComparator:^BOOL(WCTOneRow *lhs, TestCaseObject *rhs) {
                            if (lhs.count != 2) {
                                return NO;
                            }
                            return lhs[0].numberValue.intValue == rhs.variable1 && lhs[1].numberValue.doubleValue == rhs.variable3;
                          }]);
}

- (void)test_get_rows_onResults_orderBy_limit_offset
{
    WCTColumnsXRows *rows = [_table getRowsOnResults:{TestCaseObject.variable1, TestCaseObject.variable3}
                                             orderBy:_descendingOrder
                                               limit:_limit1
                                              offset:_offset1];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithArray:_preInserted];
    result = result.reversed;
    result = [NSMutableArray<TestCaseObject *> arrayWithObject:result[1]];
    XCTAssertTrue([rows isEqualToObjects:result
                          withComparator:^BOOL(WCTOneRow *lhs, TestCaseObject *rhs) {
                            if (lhs.count != 2) {
                                return NO;
                            }
                            return lhs[0].numberValue.intValue == rhs.variable1 && lhs[1].numberValue.doubleValue == rhs.variable3;
                          }]);
}

- (void)test_get_rows_onResults_where_orderBy_limit_offset
{
    WCTColumnsXRows *rows = [_table getRowsOnResults:{TestCaseObject.variable1, TestCaseObject.variable3}
                                               where:_removeBothEndCondition
                                             orderBy:_descendingOrder
                                               limit:_limit1
                                              offset:_offset1];
    NSMutableArray<TestCaseObject *> *result = [NSMutableArray<TestCaseObject *> arrayWithArray:_preInserted];
    [result removeObjectAtIndex:0];
    [result removeLastObject];
    result = result.reversed;
    result = [NSMutableArray<TestCaseObject *> arrayWithObject:result[1]];
    XCTAssertTrue([rows isEqualToObjects:result
                          withComparator:^BOOL(WCTOneRow *lhs, TestCaseObject *rhs) {
                            if (lhs.count != 2) {
                                return NO;
                            }
                            return lhs[0].numberValue.intValue == rhs.variable1 && lhs[1].numberValue.doubleValue == rhs.variable3;
                          }]);
}

#pragma mark - Insert
- (void)test_insert_object
{
    TestCaseObject *object = [TestCaseObject objectWithId:(int) _preInserted.count];
    XCTAssertTrue([_table insertObject:object]);
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    [expected addObject:object];
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_insert_objects
{
    NSArray<TestCaseObject *> *objects = [TestCaseObject objectsWithCount:3 from:(int) _preInserted.count];
    XCTAssertTrue([_table insertObjects:objects]);
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    [expected addObjectsFromArray:objects];
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_insert_or_replace_object
{
    TestCaseObject *object = [TestCaseObject objectWithId:0];
    XCTAssertTrue([_table insertOrReplaceObject:object]);
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    expected[0] = object;
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_insert_or_replace_objects
{
    NSArray<TestCaseObject *> *objects = [TestCaseObject objectsWithCount:3 from:0];
    XCTAssertTrue([_table insertOrReplaceObjects:objects]);
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    expected[0] = objects[0];
    expected[1] = objects[1];
    expected[2] = objects[2];
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_insert_object_onProperties
{
    TestCaseObject *object = [TestCaseObject objectWithId:(int) _preInserted.count];
    object.isAutoIncrement = YES;
    XCTAssertTrue(([_table insertObject:object onProperties:{TestCaseObject.variable2, TestCaseObject.variable3}]));
    XCTAssertEqual(object.lastInsertedRowID, object.variable1);
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    [expected addObject:object];
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_insert_objects_onProperties
{
    NSArray<TestCaseObject *> *objects = [TestCaseObject objectsWithCount:3 from:(int) _preInserted.count];
    for (TestCaseObject *object in objects) {
        object.isAutoIncrement = YES;
    }
    XCTAssertTrue(([_table insertObjects:objects onProperties:{TestCaseObject.variable2, TestCaseObject.variable3}]));
    for (TestCaseObject *object in objects) {
        XCTAssertEqual(object.lastInsertedRowID, object.variable1);
    }
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    [expected addObjectsFromArray:objects];
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_insert_or_replace_object_onProperties
{
    TestCaseObject *object = [TestCaseObject objectWithId:0];
    XCTAssertTrue(([_table insertOrReplaceObject:object onProperties:{TestCaseObject.variable1, TestCaseObject.variable2}]));

    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    expected[0].variable2 = object.variable2;
    XCTAssertTrue([results isEqualToTestCaseObjects:expected onProperties:TestCaseObjectPropertiesVariable1 | TestCaseObjectPropertiesVariable2]);
}

- (void)test_insert_or_replace_objects_onProperties
{
    NSArray<TestCaseObject *> *objects = [TestCaseObject objectsWithCount:3 from:0];
    XCTAssertTrue(([_table insertOrReplaceObjects:objects onProperties:{TestCaseObject.variable1, TestCaseObject.variable2}]));

    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    expected[0].variable2 = objects[0].variable2;
    expected[1].variable2 = objects[1].variable2;
    expected[2].variable2 = objects[2].variable2;
    XCTAssertTrue([results isEqualToTestCaseObjects:expected onProperties:TestCaseObjectPropertiesVariable1 | TestCaseObjectPropertiesVariable2]);
}

#pragma mark - Update Properties With Object
- (void)test_update_withObject
{
    TestCaseObject *object = [TestCaseObject objectWithId:0];
    XCTAssertTrue(([_table updateRowsOnProperties:{TestCaseObject.variable2, TestCaseObject.variable3} withObject:object]));
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    for (TestCaseObject *element in expected) {
        element.variable2 = object.variable2;
        element.variable3 = object.variable3;
    }
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_update_withObject_where
{
    TestCaseObject *object = [TestCaseObject objectWithId:0];
    XCTAssertTrue(([_table updateRowsOnProperties:{TestCaseObject.variable2, TestCaseObject.variable3} withObject:object where:_greaterThan0Condition]));
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    for (TestCaseObject *element in expected) {
        if (element.variable1 > 0) {
            element.variable2 = object.variable2;
            element.variable3 = object.variable3;
        }
    }
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_update_withObject_limit
{
    TestCaseObject *object = [TestCaseObject objectWithId:0];
    XCTAssertTrue(([_table updateRowsOnProperties:{TestCaseObject.variable2, TestCaseObject.variable3} withObject:object limit:_limit1]));
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    expected[0].variable2 = object.variable2;
    expected[0].variable3 = object.variable3;
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_update_withObject_where_limit
{
    TestCaseObject *object = [TestCaseObject objectWithId:0];
    XCTAssertTrue(([_table updateRowsOnProperties:{TestCaseObject.variable2, TestCaseObject.variable3} withObject:object where:_greaterThan0Condition limit:_limit1]));
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    expected[1].variable2 = object.variable2;
    expected[1].variable3 = object.variable3;
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_update_withObject_orderBy_limit
{
    TestCaseObject *object = [TestCaseObject objectWithId:0];
    XCTAssertTrue(([_table updateRowsOnProperties:{TestCaseObject.variable2, TestCaseObject.variable3} withObject:object orderBy:_descendingOrder limit:_limit1]));
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    expected[expected.count - 1].variable2 = object.variable2;
    expected[expected.count - 1].variable3 = object.variable3;
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_update_withObject_limit_offset
{
    TestCaseObject *object = [TestCaseObject objectWithId:0];
    XCTAssertTrue(([_table updateRowsOnProperties:{TestCaseObject.variable2, TestCaseObject.variable3} withObject:object limit:_limit1 offset:_offset1]));
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    expected[1].variable2 = object.variable2;
    expected[1].variable3 = object.variable3;
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_update_withObject_where_orderBy_limit
{
    TestCaseObject *object = [TestCaseObject objectWithId:0];
    XCTAssertTrue(([_table updateRowsOnProperties:{TestCaseObject.variable2, TestCaseObject.variable3} withObject:object where:_removeBothEndCondition orderBy:_descendingOrder limit:_limit1]));
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    expected[expected.count - 2].variable2 = object.variable2;
    expected[expected.count - 2].variable3 = object.variable3;
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_update_withObject_where_limit_offset
{
    TestCaseObject *object = [TestCaseObject objectWithId:0];
    XCTAssertTrue(([_table updateRowsOnProperties:{TestCaseObject.variable2, TestCaseObject.variable3} withObject:object where:_greaterThan0Condition limit:_limit1 offset:_offset1]));
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    expected[2].variable2 = object.variable2;
    expected[2].variable3 = object.variable3;
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_update_withObject_orderBy_limit_offset
{
    TestCaseObject *object = [TestCaseObject objectWithId:0];
    XCTAssertTrue(([_table updateRowsOnProperties:{TestCaseObject.variable2, TestCaseObject.variable3} withObject:object orderBy:_descendingOrder limit:_limit1 offset:_offset1]));
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    expected[expected.count - 2].variable2 = object.variable2;
    expected[expected.count - 2].variable3 = object.variable3;
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_update_withObject_where_orderBy_limit_offset
{
    TestCaseObject *object = [TestCaseObject objectWithId:0];
    XCTAssertTrue(([_table updateRowsOnProperties:{TestCaseObject.variable2, TestCaseObject.variable3} withObject:object where:_removeBothEndCondition orderBy:_descendingOrder limit:_limit1 offset:_offset1]));
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    expected[expected.count - 3].variable2 = object.variable2;
    expected[expected.count - 3].variable3 = object.variable3;
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

#pragma mark - Update Properties With Row
- (void)test_update_withRow
{
    TestCaseObject *object = [TestCaseObject objectWithId:0];
    WCTColumnCodingRow *row = [TestCaseObject rowWithObject:object onProperties:TestCaseObjectPropertiesVariable2 | TestCaseObjectPropertiesVariable3];
    XCTAssertTrue(([_table updateRowsOnProperties:{TestCaseObject.variable2, TestCaseObject.variable3} withRow:row]));
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    for (TestCaseObject *element in expected) {
        element.variable2 = object.variable2;
        element.variable3 = object.variable3;
    }
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_update_withRow_where
{
    TestCaseObject *object = [TestCaseObject objectWithId:0];
    WCTColumnCodingRow *row = [TestCaseObject rowWithObject:object onProperties:TestCaseObjectPropertiesVariable2 | TestCaseObjectPropertiesVariable3];
    XCTAssertTrue(([_table updateRowsOnProperties:{TestCaseObject.variable2, TestCaseObject.variable3} withRow:row where:_greaterThan0Condition]));
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    for (TestCaseObject *element in expected) {
        if (element.variable1 > 0) {
            element.variable2 = object.variable2;
            element.variable3 = object.variable3;
        }
    }
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_update_withRow_limit
{
    TestCaseObject *object = [TestCaseObject objectWithId:0];
    WCTColumnCodingRow *row = [TestCaseObject rowWithObject:object onProperties:TestCaseObjectPropertiesVariable2 | TestCaseObjectPropertiesVariable3];
    XCTAssertTrue(([_table updateRowsOnProperties:{TestCaseObject.variable2, TestCaseObject.variable3} withRow:row limit:_limit1]));
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    expected[0].variable2 = object.variable2;
    expected[0].variable3 = object.variable3;
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_update_withRow_where_limit
{
    TestCaseObject *object = [TestCaseObject objectWithId:0];
    WCTColumnCodingRow *row = [TestCaseObject rowWithObject:object onProperties:TestCaseObjectPropertiesVariable2 | TestCaseObjectPropertiesVariable3];
    XCTAssertTrue(([_table updateRowsOnProperties:{TestCaseObject.variable2, TestCaseObject.variable3} withRow:row where:_greaterThan0Condition limit:_limit1]));
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    expected[1].variable2 = object.variable2;
    expected[1].variable3 = object.variable3;
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_update_withRow_orderBy_limit
{
    TestCaseObject *object = [TestCaseObject objectWithId:0];
    WCTColumnCodingRow *row = [TestCaseObject rowWithObject:object onProperties:TestCaseObjectPropertiesVariable2 | TestCaseObjectPropertiesVariable3];
    XCTAssertTrue(([_table updateRowsOnProperties:{TestCaseObject.variable2, TestCaseObject.variable3} withRow:row orderBy:_descendingOrder limit:_limit1]));
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    expected[expected.count - 1].variable2 = object.variable2;
    expected[expected.count - 1].variable3 = object.variable3;
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_update_withRow_limit_offset
{
    TestCaseObject *object = [TestCaseObject objectWithId:0];
    WCTColumnCodingRow *row = [TestCaseObject rowWithObject:object onProperties:TestCaseObjectPropertiesVariable2 | TestCaseObjectPropertiesVariable3];
    XCTAssertTrue(([_table updateRowsOnProperties:{TestCaseObject.variable2, TestCaseObject.variable3} withRow:row limit:_limit1 offset:_offset1]));
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    expected[1].variable2 = object.variable2;
    expected[1].variable3 = object.variable3;
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_update_withRow_where_orderBy_limit
{
    TestCaseObject *object = [TestCaseObject objectWithId:0];
    WCTColumnCodingRow *row = [TestCaseObject rowWithObject:object onProperties:TestCaseObjectPropertiesVariable2 | TestCaseObjectPropertiesVariable3];
    XCTAssertTrue(([_table updateRowsOnProperties:{TestCaseObject.variable2, TestCaseObject.variable3} withRow:row where:_removeBothEndCondition orderBy:_descendingOrder limit:_limit1]));
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    expected[expected.count - 2].variable2 = object.variable2;
    expected[expected.count - 2].variable3 = object.variable3;
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_update_withRow_where_limit_offset
{
    TestCaseObject *object = [TestCaseObject objectWithId:0];
    WCTColumnCodingRow *row = [TestCaseObject rowWithObject:object onProperties:TestCaseObjectPropertiesVariable2 | TestCaseObjectPropertiesVariable3];
    XCTAssertTrue(([_table updateRowsOnProperties:{TestCaseObject.variable2, TestCaseObject.variable3} withRow:row where:_greaterThan0Condition limit:_limit1 offset:_offset1]));
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    expected[2].variable2 = object.variable2;
    expected[2].variable3 = object.variable3;
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_update_withRow_orderBy_limit_offset
{
    TestCaseObject *object = [TestCaseObject objectWithId:0];
    WCTColumnCodingRow *row = [TestCaseObject rowWithObject:object onProperties:TestCaseObjectPropertiesVariable2 | TestCaseObjectPropertiesVariable3];
    XCTAssertTrue(([_table updateRowsOnProperties:{TestCaseObject.variable2, TestCaseObject.variable3} withRow:row orderBy:_descendingOrder limit:_limit1 offset:_offset1]));
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    expected[expected.count - 2].variable2 = object.variable2;
    expected[expected.count - 2].variable3 = object.variable3;
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_update_withRow_where_orderBy_limit_offset
{
    TestCaseObject *object = [TestCaseObject objectWithId:0];
    WCTColumnCodingRow *row = [TestCaseObject rowWithObject:object onProperties:TestCaseObjectPropertiesVariable2 | TestCaseObjectPropertiesVariable3];
    XCTAssertTrue(([_table updateRowsOnProperties:{TestCaseObject.variable2, TestCaseObject.variable3} withRow:row where:_removeBothEndCondition orderBy:_descendingOrder limit:_limit1 offset:_offset1]));
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    expected[expected.count - 3].variable2 = object.variable2;
    expected[expected.count - 3].variable3 = object.variable3;
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

#pragma mark - Update Property With Value
- (void)test_update_withValue
{
    TestCaseObject *object = [TestCaseObject objectWithId:0];
    WCTColumnCodingValue *value = (WCTColumnCodingValue *) object.variable2;
    XCTAssertTrue(([_table updateRowsOnProperty:TestCaseObject.variable2 withValue:value]));
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    for (TestCaseObject *element in expected) {
        element.variable2 = object.variable2;
    }
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_update_withValue_where
{
    TestCaseObject *object = [TestCaseObject objectWithId:0];
    WCTColumnCodingValue *value = (WCTColumnCodingValue *) object.variable2;
    XCTAssertTrue(([_table updateRowsOnProperty:TestCaseObject.variable2 withValue:value where:_greaterThan0Condition]));
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    for (TestCaseObject *element in expected) {
        if (element.variable1 > 0) {
            element.variable2 = object.variable2;
        }
    }
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_update_withValue_limit
{
    TestCaseObject *object = [TestCaseObject objectWithId:0];
    WCTColumnCodingValue *value = (WCTColumnCodingValue *) object.variable2;
    XCTAssertTrue(([_table updateRowsOnProperty:TestCaseObject.variable2 withValue:value limit:_limit1]));
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    expected[0].variable2 = object.variable2;
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_update_withValue_where_limit
{
    TestCaseObject *object = [TestCaseObject objectWithId:0];
    WCTColumnCodingValue *value = (WCTColumnCodingValue *) object.variable2;
    XCTAssertTrue(([_table updateRowsOnProperty:TestCaseObject.variable2 withValue:value where:_greaterThan0Condition limit:_limit1]));
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    expected[1].variable2 = object.variable2;
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_update_withValue_orderBy_limit
{
    TestCaseObject *object = [TestCaseObject objectWithId:0];
    WCTColumnCodingValue *value = (WCTColumnCodingValue *) object.variable2;
    XCTAssertTrue(([_table updateRowsOnProperty:TestCaseObject.variable2 withValue:value orderBy:_descendingOrder limit:_limit1]));
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    expected[expected.count - 1].variable2 = object.variable2;
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_update_withValue_limit_offset
{
    TestCaseObject *object = [TestCaseObject objectWithId:0];
    WCTColumnCodingValue *value = (WCTColumnCodingValue *) object.variable2;
    XCTAssertTrue(([_table updateRowsOnProperty:TestCaseObject.variable2 withValue:value limit:_limit1 offset:_offset1]));
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    expected[1].variable2 = object.variable2;
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_update_withValue_where_orderBy_limit
{
    TestCaseObject *object = [TestCaseObject objectWithId:0];
    WCTColumnCodingValue *value = (WCTColumnCodingValue *) object.variable2;
    XCTAssertTrue(([_table updateRowsOnProperty:TestCaseObject.variable2 withValue:value where:_removeBothEndCondition orderBy:_descendingOrder limit:_limit1]));
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    expected[expected.count - 2].variable2 = object.variable2;
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_update_withValue_where_limit_offset
{
    TestCaseObject *object = [TestCaseObject objectWithId:0];
    WCTColumnCodingValue *value = (WCTColumnCodingValue *) object.variable2;
    XCTAssertTrue(([_table updateRowsOnProperty:TestCaseObject.variable2 withValue:value where:_greaterThan0Condition limit:_limit1 offset:_offset1]));
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    expected[2].variable2 = object.variable2;
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_update_withValue_orderBy_limit_offset
{
    TestCaseObject *object = [TestCaseObject objectWithId:0];
    WCTColumnCodingValue *value = (WCTColumnCodingValue *) object.variable2;
    XCTAssertTrue(([_table updateRowsOnProperty:TestCaseObject.variable2 withValue:value orderBy:_descendingOrder limit:_limit1 offset:_offset1]));
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    expected[expected.count - 2].variable2 = object.variable2;
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_update_withValue_where_orderBy_limit_offset
{
    TestCaseObject *object = [TestCaseObject objectWithId:0];
    WCTColumnCodingValue *value = (WCTColumnCodingValue *) object.variable2;
    XCTAssertTrue(([_table updateRowsOnProperty:TestCaseObject.variable2 withValue:value where:_removeBothEndCondition orderBy:_descendingOrder limit:_limit1 offset:_offset1]));
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    expected[expected.count - 3].variable2 = object.variable2;
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

#pragma mark - Delete
- (void)test_delete
{
    XCTAssertTrue([_table deleteObjects]);
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    XCTAssertNotNil(results);
    XCTAssertEqual(results.count, 0);
}

- (void)test_delete_where
{
    XCTAssertTrue([_table deleteObjectsWhere:_greaterThan0Condition]);
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray array];
    for (TestCaseObject *object in _preInserted) {
        if (object.variable1 > 0) {
            continue;
        }
        [expected addObject:object];
    }
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_delete_limit
{
    XCTAssertTrue([_table deleteObjectsLimit:_limit1]);
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    [expected removeObjectAtIndex:0];
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_delete_where_limit
{
    XCTAssertTrue([_table deleteObjectsWhere:_greaterThan0Condition limit:_limit1]);
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    [expected removeObjectAtIndex:1];
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_delete_orderBy_limit
{
    XCTAssertTrue([_table deleteObjectsOrderBy:_descendingOrder limit:_limit1]);
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    [expected removeLastObject];
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_delete_limit_offset
{
    XCTAssertTrue([_table deleteObjectsLimit:_limit1 offset:_offset1]);
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    [expected removeObjectAtIndex:1];
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_delete_where_orderBy_limit
{
    XCTAssertTrue([_table deleteObjectsWhere:_removeBothEndCondition orderBy:_descendingOrder limit:_limit1]);
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    [expected removeObjectAtIndex:expected.count - 2];
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_delete_where_limit_offset
{
    XCTAssertTrue([_table deleteObjectsWhere:_greaterThan0Condition limit:_limit1 offset:_offset1]);
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    [expected removeObjectAtIndex:2];
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_delete_orderBy_limit_offset
{
    XCTAssertTrue([_table deleteObjectsOrderBy:_descendingOrder limit:_limit1 offset:_offset1]);
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    [expected removeObjectAtIndex:_preInserted.count - 2];
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

- (void)test_delete_where_orderBy_limit_offset
{
    XCTAssertTrue([_table deleteObjectsWhere:_removeBothEndCondition orderBy:_descendingOrder limit:_limit1 offset:_offset1]);
    NSMutableArray<TestCaseObject *> *results = [NSMutableArray arrayWithArray:[_table getObjects]];
    NSMutableArray<TestCaseObject *> *expected = [NSMutableArray arrayWithArray:_preInserted];
    [expected removeObjectAtIndex:_preInserted.count - 3];
    XCTAssertTrue([results isEqualToTestCaseObjects:expected]);
}

@end
