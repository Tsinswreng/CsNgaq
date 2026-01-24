# ITable API Documentation

## Overview

The `ITable` interface represents a database table in the Tsinswreng.CsSqlHelper library. It provides properties and extension methods for SQL operations, data mapping, and table management.

## Interface Definition

### ITable Properties

- `ITblMgr? TblMgr { get; set; }` - The table manager associated with this table.
- `IDictMapperShallow DictMapper { get; set; }` - Mapper for converting between objects and dictionaries.
- `Type CodeEntityType { get; set; }` - The CLR type of the entity.
- `str DbTblName { get; set; }` - The table name in the database.
- `IDictionary<str, IColumn> Columns { get; set; }` - Mapping of property names to column objects.
- `str CodeIdName { get; set; }` - The primary key property name in the entity class (default: "Id").
- `ISoftDeleteCol? SoftDelCol { get; set; }` - Soft delete column configuration.
- `IDictionary<str, str> DbColName_CodeColName { get; set; }` - Mapping from database column names to code property names.
- `IDictionary<str, Type> CodeCol_UpperType { get; set; }` - Mapping of code properties to their upper types.
- `ISqlMkr SqlMkr { get; set; }` - SQL maker for generating SQL statements.
- `IList<str> InnerAdditionalSqls { get; set; }` - Additional SQL statements inside CREATE TABLE block.
- `IList<str> OuterAdditionalSqls { get; set; }` - Additional SQL statements outside CREATE TABLE block.
- `IDictionary<Type, IUpperTypeMapFn> UpperType_DfltMapper { get; set; }` - Default mappers for upper types.

### ITable<T> Interface

Generic version of ITable that inherits from ITable.

## Extension Methods

### SQL Generation

#### `str Qt(str s)`
Quotes a string for SQL (e.g., `"field_name"` in SQLite, `` `field_name` `` in MySQL).

**Parameters:**
- `s`: The string to quote.

**Returns:** Quoted string.

#### `IColumn GetCol(str CodeColName)`
Gets a column by code property name with error handling.

**Parameters:**
- `CodeColName`: The code property name.

**Returns:** The IColumn object.

**Throws:** Exception if column not found.

#### `str ColNameToDb(str CodeColName)`
Maps a code property name to database column name.

**Parameters:**
- `CodeColName`: The code property name.

**Returns:** Database column name.

#### `str Fld(str CodeColName)`
Returns a quoted database field name for the given code property name.

**Parameters:**
- `CodeColName`: The code property name.

**Returns:** Quoted field name (e.g., `"column_name"`).

#### `str Fld(IParam CodeColNameParam)`
Returns a quoted database field name for the parameter's name.

**Parameters:**
- `CodeColNameParam`: The parameter object.

**Returns:** Quoted field name.

#### `IField Fld<T>(Expression<Func<T, obj?>> ExprMemb)`
Creates an IField for the given member expression (generic version).

**Parameters:**
- `ExprMemb`: Expression representing the member.

**Returns:** IField object.

### Parameter Management

#### `IParam Prm(str Name)`
Creates a parameter with the given name.

**Parameters:**
- `Name`: Parameter name.

**Returns:** IParam object.

#### `IParam Prm()`
Creates a parameter with a unique name based on ULID.

**Returns:** IParam object with unique name like `@_1ccGi7C87H-LETKfaB_JX`.

#### `IParam NumFieldParam(str Field, u64 Num)`
Creates a parameter for a field with a number suffix.

**Parameters:**
- `Field`: Field name.
- `Num`: Number suffix.

**Returns:** IParam object.

#### `IParam NumParam(u64 Num)`
Creates a parameter with number-based name `@_0`, `@_1`, etc.

**Parameters:**
- `Num`: Number.

**Returns:** IParam object.

#### `IList<IParam> NumParamsEndStart(u64 EndPos, u64 StartPos = 0)`
Creates a list of numbered parameters from StartPos to EndPos.

**Parameters:**
- `EndPos`: End position (inclusive).
- `StartPos`: Start position (default 0).

**Returns:** List of IParam objects.

#### `IList<IParam> NumParams(u64 StartPos, u64 EndPos)`
Creates a list of numbered parameters from StartPos to EndPos.

**Parameters:**
- `StartPos`: Start position.
- `EndPos`: End position.

**Returns:** List of IParam objects.

#### `IList<IParam> NumParams(u64 Cnt)`
Creates a list of Cnt numbered parameters starting from 0.

**Parameters:**
- `Cnt`: Number of parameters.

**Returns:** List of IParam objects.

#### `IList<IParam> Prm(u64 Start, u64 End)`
Creates a list of parameters with numeric names.

**Parameters:**
- `Start`: Start number.
- `End`: End number.

**Returns:** List of IParam objects.

### SQL Clause Generation

#### `str UpdateClause(IEnumerable<str> UpperFields)`
Generates an UPDATE SET clause.

**Parameters:**
- `UpperFields`: Field names to update.

**Returns:** SQL SET clause like `"field1 = @field1, field2 = @field2"`.

#### `str InsertClause(IEnumerable<str> RawFields)`
Generates an INSERT clause.

**Parameters:**
- `RawFields`: Field names for insertion.

**Returns:** SQL INSERT clause like `"(field1, field2) VALUES (@field1, @field2)"`.

#### `str InsertManyClause(IEnumerable<str> RawFields, u64 GroupCnt = 1000)`
Generates a bulk INSERT clause for multiple groups.

**Parameters:**
- `RawFields`: Field names.
- `GroupCnt`: Number of groups (default 1000).

**Returns:** SQL for bulk insert.

#### `str Eq(str DbColName, IParam Param)`
Generates an equality condition.

**Parameters:**
- `DbColName`: Database column name.
- `Param`: Parameter.

**Returns:** SQL equality like `"column = @param"`.

#### `str Eq(IParam Param)`
Generates an equality condition using parameter name.

**Parameters:**
- `Param`: Parameter.

**Returns:** SQL equality.

### Data Mapping

#### `IStr_Any ToCodeDict(IStr_Any DbDict)`
Converts database dictionary to code dictionary.

**Parameters:**
- `DbDict`: Database result dictionary.

**Returns:** Code property dictionary.

#### `TPo AssignEntity<TPo>(IStr_Any DbDict, TPo ToBeAssigned)`
Assigns database values to an existing entity.

**Parameters:**
- `DbDict`: Database dictionary.
- `ToBeAssigned`: Entity to assign to.

**Returns:** The assigned entity.

#### `TPo DbDictToEntity<TPo>(IStr_Any DbDict, ref TPo R)`
Converts database dictionary to entity.

**Parameters:**
- `DbDict`: Database dictionary.
- `R`: Reference to entity (will be instantiated if null).

**Returns:** The entity.

#### `TPo DbDictToEntity<TPo>(IStr_Any DbDict)`
Converts database dictionary to new entity.

**Parameters:**
- `DbDict`: Database dictionary.

**Returns:** New entity.

#### `IStr_Any ToDbDict(IStr_Any CodeDict)`
Converts code dictionary to database dictionary.

**Parameters:**
- `CodeDict`: Code property dictionary.

**Returns:** Database dictionary.

### Type Conversion

#### `obj? UpperToRaw(obj? UpperValue, str CodeColName)`
Converts upper type value to raw database value for a column.

**Parameters:**
- `UpperValue`: Upper type value.
- `CodeColName`: Code property name.

**Returns:** Raw database value.

#### `obj? UpperToRaw(obj? UpperValue, Type UpperType, str? CodeColName = null)`
Converts upper type value to raw database value.

**Parameters:**
- `UpperValue`: Upper type value.
- `UpperType`: Type of the upper value.
- `CodeColName`: Optional code property name.

**Returns:** Raw database value.

#### `obj? UpperToRaw<T>(T UpperValue, str? CodeColName = null)`
Generic version of UpperToRaw.

**Parameters:**
- `UpperValue`: Upper type value.
- `CodeColName`: Optional code property name.

**Returns:** Raw database value.

#### `obj? RawToUpper(obj? RawValue, str CodeColName)`
Converts raw database value to upper type for a column.

**Parameters:**
- `RawValue`: Raw database value.
- `CodeColName`: Code property name.

**Returns:** Upper type value.

#### `T RawToUpper<T>(obj? RawValue, str CodeColName)`
Generic version of RawToUpper.

**Parameters:**
- `RawValue`: Raw database value.
- `CodeColName`: Code property name.

**Returns:** Upper type value of type T.

### SQL Generation

#### `str SqlMkTbl()`
Generates CREATE TABLE SQL statement.

**Returns:** Complete CREATE TABLE statement.

#### `IPageQry PageSlctAll()`
Creates a page query for selecting all records.

**Returns:** IPageQry object.

### SQL Splicing

#### `ISqlSplicer SqlSplicer()`
Creates a SQL splicer for building complex queries.

**Returns:** ISqlSplicer object.

### Soft Delete Support

#### `str SqlIsNonDel()`
Generates SQL condition for non-deleted records (requires SoftDelCol to be set).

**Returns:** SQL condition like `"(del_flag = 0)"`.

**Throws:** InvalidOperationException if SoftDelCol is not defined.

## Generic Extension Methods (ITable<T>)

### `IField Fld(Expression<Func<T, obj?>> ExprMemb)`
Creates an IField for the given member expression.

**Parameters:**
- `ExprMemb`: Expression representing the member.

**Returns:** IField object.

### `ISqlSplicer<T> SqlSplicer()`
Creates a typed SQL splicer.

**Returns:** ISqlSplicer<T> object.

## Related Types

- `ERelationType`: Enum for relationship types (OneToOne, OneToMany, ManyToMany, ManyToOne).
- `JoinCond`: Class for join conditions.
- `Relation`: Class for table relationships.
- `Relations`: Class for managing relationships.

## Usage Examples

### Basic Column Operations
```csharp
var table = new MyTable();
// Get quoted field name
string fieldName = table.Fld("PropertyName"); // Returns `"property_name"`

// Create parameter
var param = table.Prm("value"); // Returns parameter @value

// Generate WHERE condition
string condition = table.Eq("id", param); // Returns "id = @value"
```

### Data Mapping
```csharp
// Convert database result to entity
var dbResult = new Dictionary<string, object?> { ["id"] = 1, ["name"] = "John" };
var entity = table.DbDictToEntity<MyEntity>(dbResult);

// Convert entity to database format
var codeDict = new Dictionary<string, object?> { ["Id"] = 1, ["Name"] = "John" };
var dbDict = table.ToDbDict(codeDict);
```

### SQL Generation
```csharp
// Generate INSERT statement
string insertSql = table.InsertClause(new[] { "Name", "Age" });
// Returns "(name, age) VALUES (@Name, @Age)"

// Generate UPDATE clause
string updateSql = table.UpdateClause(new[] { "Name", "Age" });
// Returns "name = @Name, age = @Age"
```

### Bulk Insert
```csharp
// Generate bulk insert for 3 records
string bulkInsert = table.InsertManyClause(new[] { "Id", "Name" }, 3);
// Generates SQL for inserting 3 records at once
```

This documentation covers all APIs and extension methods for the ITable interface and its generic counterpart ITable<T>.
