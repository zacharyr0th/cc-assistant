# TypeScript & Zod Validation Reference for type-generator

## Zod Schema Validation Patterns

### Core Philosophy

**"TypeScript-first"** approach with static type inference. Define validation schemas that automatically provide TypeScript types.

**Key Features:**
- **Zero dependencies** - Lightweight implementation
- **2kb core bundle** (gzipped) - Minimal footprint
- **Immutable API** - Methods return new instances
- **Ecosystem support** - Integrates with tRPC, React Hook Form, and others

### Basic Schema Definition

```typescript
import { z } from 'zod';

// Primitives
const stringSchema = z.string();
const numberSchema = z.number();
const booleanSchema = z.boolean();
const dateSchema = z.date();

// Object schema
const UserSchema = z.object({
  name: z.string(),
  email: z.string().email(),
  age: z.number().positive().int(),
  isActive: z.boolean().default(true)
});

// Type inference
type User = z.infer<typeof UserSchema>;
// Result: { name: string; email: string; age: number; isActive: boolean }
```

### Validation Methods

**parse() - Throws on validation failure:**
```typescript
try {
  const data = UserSchema.parse(input);
  // data is fully typed as User
  console.log(data.email); // ✅ TypeScript knows this exists
} catch (error) {
  if (error instanceof z.ZodError) {
    console.error(error.issues);
  }
}
```

**safeParse() - Returns result object (recommended for API routes):**
```typescript
const result = UserSchema.safeParse(input);

if (result.success) {
  console.log(result.data); // ✅ Typed as User
} else {
  console.error(result.error.issues);
  // Array of validation errors with paths and messages
}
```

### Advanced Validation

**String validations:**
```typescript
z.string()
  .min(3, { message: 'Must be at least 3 characters' })
  .max(100)
  .email()
  .url()
  .uuid()
  .regex(/^[a-z]+$/, 'Lowercase letters only')
  .trim()
  .toLowerCase()
```

**Number validations:**
```typescript
z.number()
  .positive()
  .int()
  .min(0)
  .max(100)
  .multipleOf(5)
  .finite() // Not Infinity or NaN
```

**Optional and nullable:**
```typescript
z.string().optional()  // string | undefined
z.string().nullable()  // string | null
z.string().nullish()   // string | null | undefined

// With default
z.string().default('default value')
```

**Enums:**
```typescript
const RoleSchema = z.enum(['admin', 'user', 'guest']);
type Role = z.infer<typeof RoleSchema>; // 'admin' | 'user' | 'guest'

// Native TypeScript enum
enum Role {
  ADMIN = 'admin',
  USER = 'user'
}
const RoleSchema = z.nativeEnum(Role);
```

**Arrays:**
```typescript
z.array(z.string())           // string[]
z.string().array()            // string[] (alternative syntax)
z.array(z.number()).min(1)    // At least 1 element
z.array(UserSchema).max(10)   // Max 10 users
```

**Unions and intersections:**
```typescript
// Union (OR)
const StringOrNumber = z.union([z.string(), z.number()]);
const StringOrNumber = z.string().or(z.number()); // Alternative

// Intersection (AND)
const Combined = z.intersection(
  z.object({ name: z.string() }),
  z.object({ email: z.string() })
);

// Discriminated union
const EventSchema = z.discriminatedUnion('type', [
  z.object({ type: z.literal('click'), x: z.number(), y: z.number() }),
  z.object({ type: z.literal('keypress'), key: z.string() })
]);
```

**Transformations:**
```typescript
// Coerce types
z.coerce.number() // Converts string to number
z.coerce.boolean() // Converts truthy/falsy to boolean
z.coerce.date() // Converts string to Date

// Custom transformations
const TrimmedString = z.string().transform(s => s.trim());

// Complex transformation with validation
const DateFromString = z.string()
  .regex(/^\d{4}-\d{2}-\d{2}$/)
  .transform(s => new Date(s));
```

**Refinements (custom validation):**
```typescript
const PasswordSchema = z.string()
  .min(8)
  .refine(
    (password) => /[A-Z]/.test(password),
    { message: 'Must contain uppercase letter' }
  )
  .refine(
    (password) => /[0-9]/.test(password),
    { message: 'Must contain number' }
  );

// Multiple field validation
const RegistrationSchema = z.object({
  password: z.string(),
  confirmPassword: z.string()
}).refine(
  (data) => data.password === data.confirmPassword,
  {
    message: "Passwords don't match",
    path: ['confirmPassword'] // Error attached to confirmPassword field
  }
);
```

### Object Schema Patterns

**Partial and required:**
```typescript
const UserSchema = z.object({
  name: z.string(),
  email: z.string(),
  age: z.number()
});

const PartialUser = UserSchema.partial();
// All fields optional: { name?: string; email?: string; age?: number }

const RequiredUser = PartialUser.required();
// All fields required again

// Selective partial
const PickedSchema = UserSchema.pick({ name: true, email: true });
// Only name and email
```

**Extend and merge:**
```typescript
const BaseUser = z.object({
  name: z.string(),
  email: z.string()
});

const AdminUser = BaseUser.extend({
  role: z.literal('admin'),
  permissions: z.array(z.string())
});

// Merge (combines two schemas)
const MergedSchema = BaseUser.merge(z.object({ age: z.number() }));
```

**Deep partial:**
```typescript
const NestedSchema = z.object({
  user: z.object({
    name: z.string(),
    settings: z.object({
      theme: z.string()
    })
  })
});

const DeepPartial = NestedSchema.deepPartial();
// All nested fields optional
```

### Error Handling

**Structured error information:**
```typescript
const result = schema.safeParse(data);

if (!result.success) {
  const errors = result.error.issues;
  // Array of: { code, path, message, ... }

  errors.forEach(err => {
    console.log(err.path);    // ['user', 'email']
    console.log(err.message); // 'Invalid email'
    console.log(err.code);    // 'invalid_string'
  });

  // Format for API response
  return {
    error: 'Validation failed',
    details: result.error.flatten()
  };
}
```

**Custom error messages:**
```typescript
const schema = z.object({
  email: z.string().email('Please enter a valid email address'),
  age: z.number({
    required_error: 'Age is required',
    invalid_type_error: 'Age must be a number'
  }).min(18, 'Must be at least 18 years old')
});
```

### Best Practices

1. **Define schemas at module level** - Reusable and testable
2. **Use safeParse in API routes** - Better error handling
3. **Use parse in internal functions** - Fail fast
4. **Infer types from schemas** - Single source of truth
5. **Add custom messages** - Improve user experience
6. **Use refinements for complex validation** - Cross-field checks
7. **Transform early** - Coerce and normalize data at API boundary
8. **Keep schemas focused** - Small, composable schemas

### Integration Example (API Route)

```typescript
import { z } from 'zod';
import { NextRequest, NextResponse } from 'next/server';

const CreateUserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(1).max(100),
  age: z.number().positive().int().optional(),
  role: z.enum(['user', 'admin']).default('user')
});

export async function POST(request: NextRequest) {
  const body = await request.json();
  const validation = CreateUserSchema.safeParse(body);

  if (!validation.success) {
    return NextResponse.json(
      {
        error: 'Validation failed',
        details: validation.error.issues
      },
      { status: 400 }
    );
  }

  const { email, name, age, role } = validation.data;
  // ✅ Fully typed and validated

  // ... create user

  return NextResponse.json({ success: true });
}
```

---

**Source:** Zod Documentation
**Last Updated:** 2025-10-25
