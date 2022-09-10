CREATE MIGRATION m1fqcotglyxxnatw6b3qrhgdk2w5jn67p73jcg47f6w7c7xbvn5k4a
    ONTO m1nvelw64n2c4t35zywyklgtubudlnqmbi5y6rbc36pyyln3kezovq
{
  ALTER TYPE default::User {
      ALTER PROPERTY paswword {
          RENAME TO password;
      };
  };
};
