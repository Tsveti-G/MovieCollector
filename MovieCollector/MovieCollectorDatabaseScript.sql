USE [MovieCollector]
GO
/****** Object:  Table [dbo].[Directors]    Script Date: 7/25/2014 11:03:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Directors](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
 CONSTRAINT [PK_Directors] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Genres]    Script Date: 7/25/2014 11:03:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Genres](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
 CONSTRAINT [PK_Genres] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Movies]    Script Date: 7/25/2014 11:03:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Movies](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NULL,
	[Year] [int] NULL,
	[IDGenre] [int] NULL,
	[IDDirector] [int] NULL,
 CONSTRAINT [PK_Movies] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MoviesCast]    Script Date: 7/25/2014 11:03:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MoviesCast](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDMovie] [int] NULL,
	[IDMovieStar] [int] NULL,
 CONSTRAINT [PK_MoviesCast] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MovieStars]    Script Date: 7/25/2014 11:03:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovieStars](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
 CONSTRAINT [PK_MovieStars] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


GO
SET IDENTITY_INSERT [dbo].[Genres] ON 

GO
INSERT [dbo].[Genres] ([ID], [Name]) VALUES (1, N'Action')
GO
INSERT [dbo].[Genres] ([ID], [Name]) VALUES (2, N'Adventure')
GO
INSERT [dbo].[Genres] ([ID], [Name]) VALUES (3, N'Comedy')
GO
INSERT [dbo].[Genres] ([ID], [Name]) VALUES (4, N'Crime')
GO
INSERT [dbo].[Genres] ([ID], [Name]) VALUES (5, N'Fantasy')
GO
INSERT [dbo].[Genres] ([ID], [Name]) VALUES (6, N'Historical')
GO
INSERT [dbo].[Genres] ([ID], [Name]) VALUES (7, N'Horror')
GO
INSERT [dbo].[Genres] ([ID], [Name]) VALUES (8, N'Mystery')
GO
INSERT [dbo].[Genres] ([ID], [Name]) VALUES (9, N'Paranoid')
GO
INSERT [dbo].[Genres] ([ID], [Name]) VALUES (10, N'Philosophical')
GO
INSERT [dbo].[Genres] ([ID], [Name]) VALUES (11, N'Political')
GO
INSERT [dbo].[Genres] ([ID], [Name]) VALUES (12, N'Realistic')
GO
INSERT [dbo].[Genres] ([ID], [Name]) VALUES (13, N'Romance')
GO
INSERT [dbo].[Genres] ([ID], [Name]) VALUES (14, N'Saga')
GO
INSERT [dbo].[Genres] ([ID], [Name]) VALUES (15, N'Science fiction')
GO
INSERT [dbo].[Genres] ([ID], [Name]) VALUES (16, N'Thriller')
GO
INSERT [dbo].[Genres] ([ID], [Name]) VALUES (17, N'Animation')
GO
INSERT [dbo].[Genres] ([ID], [Name]) VALUES (18, N'Drama')
GO
SET IDENTITY_INSERT [dbo].[Genres] OFF

GO
ALTER TABLE [dbo].[Movies]  WITH CHECK ADD  CONSTRAINT [FK_Movies_Directors] FOREIGN KEY([IDDirector])
REFERENCES [dbo].[Directors] ([ID])
GO
ALTER TABLE [dbo].[Movies] CHECK CONSTRAINT [FK_Movies_Directors]
GO
ALTER TABLE [dbo].[Movies]  WITH CHECK ADD  CONSTRAINT [FK_Movies_Genres] FOREIGN KEY([IDGenre])
REFERENCES [dbo].[Genres] ([ID])
GO
ALTER TABLE [dbo].[Movies] CHECK CONSTRAINT [FK_Movies_Genres]
GO
ALTER TABLE [dbo].[MoviesCast]  WITH CHECK ADD  CONSTRAINT [FK_MoviesCast_Movies] FOREIGN KEY([IDMovie])
REFERENCES [dbo].[Movies] ([ID])
GO
ALTER TABLE [dbo].[MoviesCast] CHECK CONSTRAINT [FK_MoviesCast_Movies]
GO
ALTER TABLE [dbo].[MoviesCast]  WITH CHECK ADD  CONSTRAINT [FK_MoviesCast_MovieStars] FOREIGN KEY([IDMovieStar])
REFERENCES [dbo].[MovieStars] ([ID])
GO
ALTER TABLE [dbo].[MoviesCast] CHECK CONSTRAINT [FK_MoviesCast_MovieStars]
GO
