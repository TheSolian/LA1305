import cors from 'cors'
import express from 'express'
import { prisma } from '../prisma/client'

const app = express()

app.use(cors())
app.use(express.json())
app.use(express.urlencoded({ extended: true }))

app.get('/tasks', async (req, res) => {
  const tasks = await prisma.task.findMany()

  res.json(tasks)
})

app.post('/save-task', async (req, res) => {
  const { id, title, description, isCompleted } = req.body

  const task = await prisma.task.upsert({
    where: { id },
    update: { title, description, isCompleted },
    create: { id, title, description, isCompleted },
  })

  res.json(task)
})

app.delete('/delete-task/:id', async (req, res) => {
  const { id } = req.params

  try {
    const task = await prisma.task.delete({
      where: { id },
    })
    if (task) {
      res.json({ success: true })
    }
  } catch (error) {
    res.json({ success: false })
  }
})

app.listen(8000, () => console.log('Server is running on port 8000'))
