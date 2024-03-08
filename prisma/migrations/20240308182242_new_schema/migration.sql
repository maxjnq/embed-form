-- CreateTable
CREATE TABLE "List" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "userId" TEXT NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "name" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "content" TEXT,
    "listSignUpPageId" TEXT NOT NULL,
    "listSignUpFormId" TEXT NOT NULL,
    "listConfirmationPageId" TEXT NOT NULL,
    "listConfirmationEmailId" TEXT NOT NULL,
    "listSettingsId" TEXT NOT NULL,
    CONSTRAINT "List_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "List_listSignUpPageId_fkey" FOREIGN KEY ("listSignUpPageId") REFERENCES "ListSignUpPage" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "List_listSignUpFormId_fkey" FOREIGN KEY ("listSignUpFormId") REFERENCES "ListSignUpForm" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "List_listConfirmationPageId_fkey" FOREIGN KEY ("listConfirmationPageId") REFERENCES "ListConfirmationPage" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "List_listConfirmationEmailId_fkey" FOREIGN KEY ("listConfirmationEmailId") REFERENCES "ListConfirmationEmail" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "List_listSettingsId_fkey" FOREIGN KEY ("listSettingsId") REFERENCES "ListSettings" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Sub" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "isGDPR" BOOLEAN NOT NULL DEFAULT false,
    "isVerified" BOOLEAN NOT NULL DEFAULT false,
    "verifyToken" TEXT,
    "shortId" TEXT NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdDay" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "referredById" TEXT,
    "referrals" INTEGER NOT NULL DEFAULT 0,
    "position" INTEGER,
    "listId" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "name" TEXT,
    "trackingId" TEXT,
    CONSTRAINT "Sub_referredById_fkey" FOREIGN KEY ("referredById") REFERENCES "Sub" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Sub_listId_fkey" FOREIGN KEY ("listId") REFERENCES "List" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "Sub_trackingId_fkey" FOREIGN KEY ("trackingId") REFERENCES "Tracking" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Tracking" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "shortId" TEXT NOT NULL,
    "name" TEXT NOT NULL DEFAULT 'Somewhere',
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "ip" TEXT,
    "userAgent" TEXT,
    "referer" TEXT,
    "country" TEXT,
    "city" TEXT,
    "region" TEXT,
    "latitude" REAL,
    "longitude" REAL,
    "listId" TEXT,
    CONSTRAINT "Tracking_listId_fkey" FOREIGN KEY ("listId") REFERENCES "List" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "ListSettings" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "logoWidth" INTEGER NOT NULL DEFAULT 80,
    "accentColor" TEXT NOT NULL DEFAULT '#1CC94D',
    "borderColor" TEXT NOT NULL DEFAULT '#E5E5E5',
    "textColor" TEXT NOT NULL DEFAULT '#000000',
    "backgroundPageColor" TEXT NOT NULL DEFAULT '#FFFFFF',
    "backgroundInputColor" TEXT NOT NULL DEFAULT '#F8F8F8',
    "buttonTextColor" TEXT NOT NULL DEFAULT '#000000',
    "inputHeight" TEXT NOT NULL DEFAULT '55px',
    "radius" TEXT NOT NULL DEFAULT '8px',
    "borderWidth" TEXT NOT NULL DEFAULT '1px',
    "loadingBarHeight" TEXT NOT NULL DEFAULT '2px',
    "startFrom" INTEGER NOT NULL DEFAULT 0
);

-- CreateTable
CREATE TABLE "Link" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "url" TEXT NOT NULL,
    "title" TEXT,
    "listSettingsId" TEXT,
    "userId" TEXT,
    CONSTRAINT "Link_listSettingsId_fkey" FOREIGN KEY ("listSettingsId") REFERENCES "ListSettings" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Link_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "ListSignUpPage" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "title" TEXT NOT NULL DEFAULT 'Join my waitlist',
    "placeholder" TEXT NOT NULL DEFAULT 'Enter your email',
    "cta" TEXT NOT NULL DEFAULT 'Join',
    "description" TEXT NOT NULL DEFAULT 'My cool product is coming soon! Join the waitlist to be the first to know when it''s ready.',
    "enableLogo" BOOLEAN NOT NULL DEFAULT true,
    "enableName" BOOLEAN NOT NULL DEFAULT true,
    "enablePage" BOOLEAN NOT NULL DEFAULT true,
    "redirectUrl" TEXT DEFAULT '',
    "news" TEXT DEFAULT '100 subscribers in 24 hours!',
    "content" TEXT NOT NULL DEFAULT 'Here is some content to help you understand what you''re signing up for.'
);

-- CreateTable
CREATE TABLE "ListSignUpForm" (
    "id" TEXT NOT NULL PRIMARY KEY
);

-- CreateTable
CREATE TABLE "ListConfirmationPage" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "title" TEXT NOT NULL DEFAULT 'You''ve been added to the list!',
    "description" TEXT NOT NULL DEFAULT 'You''ll receive an email shortly to confirm your subscription.',
    "content" TEXT NOT NULL DEFAULT '',
    "cta" TEXT NOT NULL DEFAULT 'Send invite',
    "placeholder" TEXT NOT NULL DEFAULT 'Your friend''s email'
);

-- CreateTable
CREATE TABLE "ListConfirmationEmail" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "subject" TEXT NOT NULL DEFAULT 'Thank you for signing up!',
    "preview" TEXT NOT NULL DEFAULT 'Welcome! So cool to have you here.',
    "replyto" TEXT NOT NULL DEFAULT 'elon@musk.com',
    "from" TEXT NOT NULL DEFAULT 'mail@wt.ls',
    "body" TEXT NOT NULL DEFAULT 'Welcome to the list! We''re so excited to have you here. You''ll be the first to know when we''re ready to launch.'
);

-- CreateTable
CREATE TABLE "ListImage" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "altText" TEXT,
    "contentType" TEXT NOT NULL,
    "blob" BLOB NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "listId" TEXT NOT NULL,
    CONSTRAINT "ListImage_listId_fkey" FOREIGN KEY ("listId") REFERENCES "List" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "ListIcon" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "altText" TEXT,
    "contentType" TEXT NOT NULL,
    "blob" BLOB NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "listId" TEXT NOT NULL,
    CONSTRAINT "ListIcon_listId_fkey" FOREIGN KEY ("listId") REFERENCES "List" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "ListLogo" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "altText" TEXT,
    "contentType" TEXT NOT NULL,
    "blob" BLOB NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "listId" TEXT NOT NULL,
    CONSTRAINT "ListLogo_listId_fkey" FOREIGN KEY ("listId") REFERENCES "List" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "ListGraphQLImage" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "altText" TEXT,
    "contentType" TEXT NOT NULL,
    "blob" BLOB NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "listId" TEXT NOT NULL,
    CONSTRAINT "ListGraphQLImage_listId_fkey" FOREIGN KEY ("listId") REFERENCES "List" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "WebhookEvent" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "eventName" TEXT NOT NULL,
    "processed" BOOLEAN NOT NULL DEFAULT false,
    "body" TEXT NOT NULL,
    "processingError" TEXT
);

-- CreateTable
CREATE TABLE "Plan" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "productId" INTEGER NOT NULL,
    "planId" INTEGER NOT NULL,
    "name" TEXT,
    "description" TEXT,
    "variantName" TEXT NOT NULL,
    "sort" INTEGER NOT NULL,
    "status" TEXT NOT NULL,
    "price" INTEGER NOT NULL,
    "interval" TEXT NOT NULL,
    "intervalCount" INTEGER NOT NULL DEFAULT 1
);

-- CreateTable
CREATE TABLE "Subscription" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "lemonId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "variantName" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "customerPortalLink" TEXT NOT NULL,
    "price" INTEGER NOT NULL,
    "updatePaymentMethodLink" TEXT NOT NULL,
    "limit" INTEGER NOT NULL DEFAULT 250,
    "renewsAt" DATETIME,
    "endsAt" DATETIME,
    "trialEndsAt" DATETIME,
    "resumesAt" DATETIME,
    "cancelled" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "userId" TEXT NOT NULL,
    "planId" INTEGER NOT NULL,
    CONSTRAINT "Subscription_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "Subscription_planId_fkey" FOREIGN KEY ("planId") REFERENCES "Plan" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Feedback" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "title" TEXT,
    "message" TEXT NOT NULL,
    "votes" INTEGER NOT NULL DEFAULT 0,
    "userId" TEXT NOT NULL,
    CONSTRAINT "Feedback_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "ListMetrics" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "subs" INTEGER NOT NULL DEFAULT 0,
    "listId" TEXT NOT NULL,
    CONSTRAINT "ListMetrics_listId_fkey" FOREIGN KEY ("listId") REFERENCES "List" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_User" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "email" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "name" TEXT,
    "autoUpgrade" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL
);
INSERT INTO "new_User" ("createdAt", "email", "id", "name", "updatedAt", "username") SELECT "createdAt", "email", "id", "name", "updatedAt", "username" FROM "User";
DROP TABLE "User";
ALTER TABLE "new_User" RENAME TO "User";
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");
CREATE UNIQUE INDEX "User_username_key" ON "User"("username");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;

-- CreateIndex
CREATE UNIQUE INDEX "List_url_key" ON "List"("url");

-- CreateIndex
CREATE INDEX "List_userId_idx" ON "List"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Sub_verifyToken_key" ON "Sub"("verifyToken");

-- CreateIndex
CREATE UNIQUE INDEX "Sub_shortId_key" ON "Sub"("shortId");

-- CreateIndex
CREATE INDEX "Sub_listId_idx" ON "Sub"("listId");

-- CreateIndex
CREATE INDEX "Sub_createdAt_idx" ON "Sub"("createdAt");

-- CreateIndex
CREATE INDEX "Sub_createdDay_idx" ON "Sub"("createdDay");

-- CreateIndex
CREATE INDEX "Sub_listId_createdAt_idx" ON "Sub"("listId", "createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "Tracking_shortId_key" ON "Tracking"("shortId");

-- CreateIndex
CREATE INDEX "ListImage_listId_idx" ON "ListImage"("listId");

-- CreateIndex
CREATE UNIQUE INDEX "ListIcon_listId_key" ON "ListIcon"("listId");

-- CreateIndex
CREATE INDEX "ListIcon_listId_idx" ON "ListIcon"("listId");

-- CreateIndex
CREATE UNIQUE INDEX "ListLogo_listId_key" ON "ListLogo"("listId");

-- CreateIndex
CREATE INDEX "ListLogo_listId_idx" ON "ListLogo"("listId");

-- CreateIndex
CREATE UNIQUE INDEX "ListGraphQLImage_listId_key" ON "ListGraphQLImage"("listId");

-- CreateIndex
CREATE INDEX "ListGraphQLImage_listId_idx" ON "ListGraphQLImage"("listId");

-- CreateIndex
CREATE UNIQUE INDEX "Plan_planId_key" ON "Plan"("planId");

-- CreateIndex
CREATE UNIQUE INDEX "Subscription_userId_key" ON "Subscription"("userId");
